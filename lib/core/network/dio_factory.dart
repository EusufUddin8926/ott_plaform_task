import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ott_platform_task/core/constants/app_constant.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";

class DioFactory {
  Future<Dio> getDio() async {
    Dio dio = Dio();

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
    };

    dio.options = BaseOptions(
      baseUrl: AppConstant.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      receiveDataWhenStatusError: true,
      headers: headers,
    );

    dio.options.validateStatus = (status) {
      return status != null;
    };

    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ));
    }

    /* // Add the interceptor
    dio.interceptors.add(ApiInterceptors());*/

    return dio;
  }
}
