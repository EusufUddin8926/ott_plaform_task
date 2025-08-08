import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ott_platform_task/core/constants/app_constant.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE_JSON = "text/plain";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";

class DioFactory {
  Future<Dio> getDio() async {
    Dio dio = Dio();
    Map<String, String> headers;



    if (!kIsWeb) {
       headers = {
        CONTENT_TYPE: APPLICATION_JSON,
        ACCEPT: APPLICATION_JSON,
      };
    }else{
      headers = {
        CONTENT_TYPE: CONTENT_TYPE_JSON,
        ACCEPT: APPLICATION_JSON,
      };
    }

    // Common options
    dio.options = BaseOptions(
      baseUrl: AppConstant.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      receiveDataWhenStatusError: true,
      headers: headers,
    );

    // Set sendTimeout only if NOT Web
    if (!kIsWeb) {
      dio.options.sendTimeout = const Duration(seconds: 60);
    }

    dio.options.validateStatus = (status) => status != null;

    // Logging
    if (!kReleaseMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ));
    }

    return dio;
  }
}

