import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:kipa/core/constants/api_constants.dart';
import 'package:kipa/utils/constant.dart';

import 'auth_token_service.dart';

class AppDio extends DioForNative {
  AppDio(BaseOptions super.options);
  factory AppDio.fromConfig() {
    final instance = AppDio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        contentType: Headers.jsonContentType,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        validateStatus: (status) => true,
      ),
    );
    instance.interceptors.add(_AppNetworkInterceptor());
    return instance;
  }
}

class _AppNetworkInterceptor extends Interceptor {
  final AuthTokenService _authTokenService = getIt<AuthTokenService>();

  @override
  onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      "=========> Error with request: ${err.requestOptions.path} ============> \n status code: ${err.response?.statusCode}",
    );
    log("Headers: ${err.requestOptions.headers}");
    log("Data: ${err.requestOptions.data}");

    if (err.response?.statusCode == 401) {
      _authTokenService.handleTokenExpiration();
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      "=========> Response from request: ${response.requestOptions.path} ============> \n response: ${response.data} \n statusCode: ${response.statusCode},\n requestBody: ${response.requestOptions.data} ",
    );

    if (response.statusCode == 401) {
      _authTokenService.handleTokenExpiration();
    }

    super.onResponse(response, handler);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth token if available
    final token = await _authTokenService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    log("=========> Full Request details for: ${options.path} ============>");
    log("Method: ${options.method}");
    log("Content-Type: ${options.contentType}");
    log("Headers: ${options.headers}");

    handler.next(options);
  }
}
