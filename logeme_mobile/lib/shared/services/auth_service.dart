import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  final ApiClient _client = ApiClient();
  String? accessToken;
  String? refreshToken;
  UserModel? currentUser;

  AuthService() {
    ApiClient.configureAuth(
      getAccessToken: () async => accessToken,
      refreshToken: refreshAccessToken,
    );
  }

  bool get isLoggedIn => accessToken != null;

  Options get authOptions =>
      Options(headers: {'Authorization': 'Bearer $accessToken'});

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access');
    refreshToken = prefs.getString('refresh');
    if (accessToken != null) {
      await fetchMe();
    }
    notifyListeners();
  }

  Future<bool> refreshAccessToken() async {
    if (refreshToken == null) return false;
    try {
      final res = await _client.dio.post('/api/auth/refresh/', data: {
        'refresh': refreshToken,
      });
      final newAccess = res.data['access'] as String?;
      final newRefresh = res.data['refresh'] as String?;
      if (newAccess == null) return false;
      accessToken = newAccess;
      if (newRefresh != null) {
        refreshToken = newRefresh;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access', accessToken!);
      if (refreshToken != null) {
        await prefs.setString('refresh', refreshToken!);
      }
      notifyListeners();
      return true;
    } catch (_) {
      await logout(clearRemote: false);
      return false;
    }
  }

  Future<void> fetchMe() async {
    if (accessToken == null) return;
    final res = await _client.dio.get('/api/users/me/', options: authOptions);
    currentUser = UserModel.fromJson(res.data);
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? idDocumentPath,
  }) async {
    final data = FormData.fromMap({
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'role': role,
      if (idDocumentPath != null && idDocumentPath.isNotEmpty)
        'id_document': await MultipartFile.fromFile(idDocumentPath),
    });

    await _client.dio.post('/api/auth/register/', data: data);
    await _client.dio.post('/api/auth/verify-email/', data: {'email': email});
  }

  Future<void> login(String email, String password) async {
    final response = await _client.dio.post('/api/auth/login/', data: {
      'email': email,
      'password': password,
    });
    accessToken = response.data['access'];
    refreshToken = response.data['refresh'];
    currentUser = UserModel.fromJson(response.data['user']);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access', accessToken!);
    await prefs.setString('refresh', refreshToken!);
    notifyListeners();
  }

  Future<void> logout({bool clearRemote = true}) async {
    if (clearRemote && refreshToken != null) {
      await _client.dio.post('/api/auth/logout/', data: {'refresh': refreshToken});
    }
    accessToken = null;
    refreshToken = null;
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    await _client.dio.post('/api/auth/forgot-password/', data: {'email': email});
  }
}
