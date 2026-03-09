import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/listing_model.dart';
import 'api_client.dart';

class FavoriteService extends ChangeNotifier {
  final ApiClient _client = ApiClient();
  List<Map<String, dynamic>> rawFavorites = [];

  List<ListingModel> get listings => rawFavorites
      .map((e) => ListingModel.fromJson(Map<String, dynamic>.from(e['listing_data'] ?? {})))
      .toList();

  Future<void> fetchFavorites(String token) async {
    final response = await _client.dio.get(
      '/api/favorites/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    rawFavorites = (response.data as List).cast<Map<String, dynamic>>();
    notifyListeners();
  }

  Future<void> addFavorite(String token, int listingId) async {
    await _client.dio.post(
      '/api/favorites/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: {'listing': listingId},
    );
    await fetchFavorites(token);
  }

  Future<void> removeFavorite(String token, int favoriteId) async {
    await _client.dio.delete(
      '/api/favorites/$favoriteId/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    await fetchFavorites(token);
  }

  Future<void> reportListing(String token, int listingId, String reason) async {
    await _client.dio.post(
      '/api/reports/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      data: {'listing': listingId, 'reason': reason},
    );
  }
}
