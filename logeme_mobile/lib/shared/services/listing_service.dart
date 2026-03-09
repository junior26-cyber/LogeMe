import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/listing_model.dart';
import 'api_client.dart';

class ListingService extends ChangeNotifier {
  final ApiClient _client = ApiClient();
  List<ListingModel> listings = [];
  List<ListingModel> myListings = [];
  bool isLoading = false;

  Future<void> fetchListings({
    String? city,
    String? type,
    String? neighborhood,
    int? priceMin,
    int? priceMax,
  }) async {
    isLoading = true;
    notifyListeners();
    final response = await _client.dio.get('/api/listings/', queryParameters: {
      if (city != null && city.isNotEmpty) 'city': city,
      if (type != null && type.isNotEmpty) 'type': type,
      if (neighborhood != null && neighborhood.isNotEmpty) 'neighborhood': neighborhood,
      if (priceMin != null) 'price_min': priceMin,
      if (priceMax != null) 'price_max': priceMax,
    });
    listings = (response.data as List)
        .map((item) => ListingModel.fromJson(item as Map<String, dynamic>))
        .toList();
    isLoading = false;
    notifyListeners();
  }

  Future<ListingModel> fetchDetail(int id) async {
    final response = await _client.dio.get('/api/listings/$id/');
    return ListingModel.fromJson(response.data);
  }

  Future<void> fetchMyListings(String token) async {
    final response = await _client.dio.get(
      '/api/listings/my/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    myListings = (response.data as List)
        .map((item) => ListingModel.fromJson(item as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchStats(String token) async {
    final response = await _client.dio.get(
      '/api/listings/stats/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> createListing({
    required String token,
    required String title,
    required String description,
    required int price,
    required String type,
    required String neighborhood,
    required double lat,
    required double lng,
    required List<String> photoPaths,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'description': description,
      'price': price,
      'type': type,
      'neighborhood': neighborhood,
      'city': 'Lomé',
      'country': 'Togo',
      'gps_latitude': lat,
      'gps_longitude': lng,
      'uploaded_photos': await Future.wait(
        photoPaths.map((p) => MultipartFile.fromFile(p)),
      ),
    });

    await _client.dio.post(
      '/api/listings/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: formData,
    );
  }

  Future<void> updateListing({
    required String token,
    required int id,
    required String title,
    required String description,
    required int price,
    required String type,
    required String neighborhood,
    required double lat,
    required double lng,
  }) async {
    await _client.dio.put(
      '/api/listings/$id/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: {
        'title': title,
        'description': description,
        'price': price,
        'type': type,
        'neighborhood': neighborhood,
        'city': 'Lomé',
        'country': 'Togo',
        'gps_latitude': lat,
        'gps_longitude': lng,
        'is_active': true,
      },
    );
  }

  Future<void> deleteListing({required String token, required int id}) async {
    await _client.dio.delete(
      '/api/listings/$id/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }
}
