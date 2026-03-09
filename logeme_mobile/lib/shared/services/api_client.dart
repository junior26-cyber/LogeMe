import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  ApiClient() {
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
  }
}
