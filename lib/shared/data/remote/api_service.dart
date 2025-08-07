import 'package:dio/dio.dart';


class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> get({
    required String endPoint,
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await _dio.get(endPoint, queryParameters: queryParams);
    return response;
  }
}
