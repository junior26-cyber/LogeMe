import 'package:dio/dio.dart';

String readableError(Object error) {
  if (error is DioException) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      if (data['detail'] != null) return data['detail'].toString();
      final first = data.values.isNotEmpty ? data.values.first : null;
      if (first is List && first.isNotEmpty) return first.first.toString();
      if (first != null) return first.toString();
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.connectionError) {
      return 'Connexion impossible au serveur.';
    }
  }
  return 'Une erreur est survenue.';
}
