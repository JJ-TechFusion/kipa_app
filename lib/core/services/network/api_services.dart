import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kipa/utils/constant.dart';

import 'auth_token_service.dart';
import 'network_response.dart';

class ApiService {
  final Dio _dio;
  final AuthTokenService _authTokenService;

  static const _excludedFrom401Logout = [
    '/wallet/pin/verify',
    '/wallet/pin',
    '/wallet/pin/status',
    '/wallet/pin/reset/confirm',
  ];

  bool _shouldHandleTokenExpiration(String? endpoint) {
    if (endpoint == null) return true;
    return !_excludedFrom401Logout.any(
      (excluded) => endpoint.contains(excluded),
    );
  }

  ApiService(Dio instance, {AuthTokenService? authTokenService})
    : _dio = instance,
      _authTokenService = authTokenService ?? getIt<AuthTokenService>();

  Future<NetworkResponse> getRequest({
    String? endpoint,
    Map<String, dynamic>? query,
    bool isProtected = true,
  }) async {
    try {
      final headers = isProtected ? await _fetchHeaders() : null;
      logMessage(
        'ApiService',
        'Making request to $endpoint with headers: $headers',
      );

      final response = await _dio.get(
        endpoint ?? '',
        queryParameters: query,
        options: Options(headers: headers),
      );

      final networkResponse = NetworkResponse.fromMap(response.data);

      if (response.statusCode == 401 && _shouldHandleTokenExpiration(endpoint)) {
        await _authTokenService.handleTokenExpiration();
        return NetworkResponse(
          success: false,
          message: 'Session expired. Please login again.',
          data: null,
          statusCode: 401,
        );
      }

      return networkResponse;
    } catch (e) {
      if (e is SocketException) {
        return NetworkResponse(
          success: false,
          message: 'Poor internet connection!',
          data: null,
          statusCode: 503,
        );
      } else if (e is DioException) {
        return await _handleDioException(e, endpoint);
      }
      return NetworkResponse(
        success: false,
        message: e.toString(),
        data: null,
        statusCode: 500,
      );
    }
  }

  Future<NetworkResponse> postRequest({
    String? endpoint,
    Map<String, dynamic>? query,
    bool isProtected = true,
    Object? requestBody,
  }) async {
    try {
      final response = await _dio.post(
        endpoint ?? '',
        queryParameters: query,
        data: requestBody,
        options: Options(
          headers: isProtected
              ? await _fetchHeaders()
              : {'Content-Type': 'application/json'},
        ),
      );

      // Check for authentication errors (401 Unauthorized)
      if (response.statusCode == 401 && _shouldHandleTokenExpiration(endpoint)) {
        await _authTokenService.handleTokenExpiration();
        return NetworkResponse(
          success: false,
          message: 'Session expired. Please login again.',
          data: null,
          statusCode: 401,
        );
      }

      return NetworkResponse.fromMap(response.data);
    } catch (e) {
      if (e is SocketException) {
        return NetworkResponse(
          success: false,
          message: 'Poor internet connection!',
          data: null,
          statusCode: 503,
        );
      } else if (e is DioException) {
        return await _handleDioException(e, endpoint);
      }
      return NetworkResponse(
        success: false,
        message: e.toString(),
        data: null,
        statusCode: 500,
      );
    }
  }

  Future<NetworkResponse> putRequest({
    String? endpoint,
    Map<String, dynamic>? query,
    bool isProtected = true,
    Object? requestBody,
  }) async {
    try {
      final response = await _dio.put(
        endpoint ?? '',
        queryParameters: query,
        data: requestBody,
        options: Options(headers: isProtected ? await _fetchHeaders() : null),
      );

      if (response.statusCode == 401 && _shouldHandleTokenExpiration(endpoint)) {
        await _authTokenService.handleTokenExpiration();
        return NetworkResponse(
          success: false,
          message: 'Session expired. Please login again.',
          data: null,
          statusCode: 401,
        );
      }

      return NetworkResponse.fromMap(response.data);
    } catch (e) {
      if (e is SocketException) {
        return NetworkResponse(
          success: false,
          message: 'Poor internet connection!',
          data: null,
          statusCode: 503,
        );
      } else if (e is DioException) {
        return await _handleDioException(e, endpoint);
      }
      return NetworkResponse(
        success: false,
        message: e.toString(),
        data: null,
        statusCode: 500,
      );
    }
  }

  Future<NetworkResponse> patchRequest({
    String? endpoint,
    Map<String, dynamic>? query,
    bool isProtected = true,
    Object? requestBody,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint ?? '',
        queryParameters: query,
        data: requestBody,
        options: Options(headers: isProtected ? await _fetchHeaders() : null),
      );

      if (response.statusCode == 401 && _shouldHandleTokenExpiration(endpoint)) {
        await _authTokenService.handleTokenExpiration();
        return NetworkResponse(
          success: false,
          message: 'Session expired. Please login again.',
          data: null,
          statusCode: 401,
        );
      }

      return NetworkResponse.fromMap(response.data);
    } catch (e) {
      if (e is SocketException) {
        return NetworkResponse(
          success: false,
          message: 'Poor internet connection!',
          data: null,
          statusCode: 503,
        );
      } else if (e is DioException) {
        return await _handleDioException(e, endpoint);
      }
      return NetworkResponse(
        success: false,
        message: e.toString(),
        data: null,
        statusCode: 500,
      );
    }
  }

  Future<NetworkResponse> deleteRequest({
    String? endpoint,
    Map<String, dynamic>? query,
    bool isProtected = true,
    Object? requestBody,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint ?? '',
        queryParameters: query,
        data: requestBody,
        options: Options(headers: isProtected ? await _fetchHeaders() : null),
      );

      if (response.statusCode == 401 && _shouldHandleTokenExpiration(endpoint)) {
        await _authTokenService.handleTokenExpiration();
        return NetworkResponse(
          success: false,
          message: 'Session expired. Please login again.',
          data: null,
          statusCode: 401,
        );
      }

      return NetworkResponse.fromMap(response.data);
    } catch (e) {
      if (e is SocketException) {
        return NetworkResponse(
          success: false,
          message: 'Poor internet connection!',
          data: null,
          statusCode: 503,
        );
      } else if (e is DioException) {
        return await _handleDioException(e, endpoint);
      }
      return NetworkResponse(
        success: false,
        message: e.toString(),
        data: null,
        statusCode: 500,
      );
    }
  }

  Future<NetworkResponse> requestWithFile({
    String? endpoint,
    Map<String, dynamic>? query,
    String fileName = '',
    DioMediaType? mimeType,
    List<int> fileBytes = const [],
    bool isProtected = true,
    Object? otherFieldsInRequest,
  }) async {
    try {
      final baseHeaders = isProtected ? await _fetchHeaders() : {};

      final Map<String, dynamic> multipartHeaders = {...baseHeaders};

      FormData formData;
      if (fileBytes.isNotEmpty && fileName.isNotEmpty) {
        formData = FormData.fromMap({
          ...?(otherFieldsInRequest as Map?),
          fileName: MultipartFile.fromBytes(
            fileBytes,
            filename: fileName,
            contentType: mimeType,
          ),
        });
      } else {
        formData = FormData.fromMap(
          otherFieldsInRequest as Map<String, dynamic>? ?? {},
        );
      }

      logMessage('ApiService', 'FormData: ${formData.fields}');
      logMessage('ApiService', 'Files: ${formData.files}');
      final response = await _dio.post(
        endpoint ?? '',
        queryParameters: query,
        data: formData,
        options: Options(headers: multipartHeaders),
      );

      if (response.statusCode == 401 && _shouldHandleTokenExpiration(endpoint)) {
        await _authTokenService.handleTokenExpiration();
        return NetworkResponse(
          success: false,
          message: 'Session expired. Please login again.',
          data: null,
          statusCode: 401,
        );
      }

      return NetworkResponse.fromMap(response.data);
    } catch (e) {
      if (e is SocketException) {
        return NetworkResponse(
          success: false,
          message: 'Poor internet connection!',
          data: null,
          statusCode: 503,
        );
      } else if (e is DioException) {
        return await _handleDioException(e, endpoint);
      }
      return NetworkResponse(
        success: false,
        message: e.toString(),
        data: null,
        statusCode: 500,
      );
    }
  }

  Future<NetworkResponse> submitKycFormData({
    required String endpoint,
    required Map<String, dynamic> formData,
  }) async {
    try {
      final baseHeaders = await _fetchHeaders();

      final Map<String, dynamic> multipartHeaders = {
        'Authorization': baseHeaders['Authorization'],
        'Accept': 'application/json',
      };

      final dioFormData = FormData.fromMap(formData);

      final response = await _dio.post(
        endpoint,
        data: dioFormData,
        options: Options(
          headers: multipartHeaders,
          receiveTimeout: const Duration(minutes: 2),
          sendTimeout: const Duration(minutes: 2),
        ),
      );

      logMessage(
        'ApiService',
        'KYC form submission response: ${response.statusCode}, data: ${response.data}',
      );

      if (response.statusCode == 401 && _shouldHandleTokenExpiration(endpoint)) {
        await _authTokenService.handleTokenExpiration();
        return NetworkResponse(
          success: false,
          message: 'Session expired. Please login again.',
          data: null,
          statusCode: 401,
        );
      }

      return NetworkResponse.fromMap(response.data);
    } catch (e) {
      logMessage('ApiService', 'Error submitting KYC form: $e');
      if (e is SocketException) {
        return NetworkResponse(
          success: false,
          message: 'Poor internet connection!',
          data: null,
          statusCode: 503,
        );
      } else if (e is DioException) {
        logMessage(
          'ApiService',
          'DioException: ${e.message}, Response: ${e.response?.data}',
        );
        if (e.response?.statusCode == 401 && _shouldHandleTokenExpiration(endpoint)) {
          await _authTokenService.handleTokenExpiration();
          return NetworkResponse(
            success: false,
            message: 'Session expired. Please login again.',
            data: null,
            statusCode: 401,
          );
        }
        return NetworkResponse(
          success: false,
          message: e.message ?? 'An error occurred during submission',
          data: null,
          statusCode: e.response?.statusCode,
        );
      }
      return NetworkResponse(
        success: false,
        message: 'Error: ${e.toString()}',
        data: null,
        statusCode: 500,
      );
    }
  }

  Future<Map<String, String>> _fetchHeaders() async {
    final token = await _authTokenService.getToken();

    if (token == null || token.isEmpty) {
      logMessage('ApiService', 'No token found! Using public headers.');
      return {'Content-Type': 'application/json', 'Accept': 'application/json'};
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    logMessage('ApiService', 'Sending headers: $headers');
    return headers;
  }

  Future<NetworkResponse> _handleDioException(DioException e, [String? endpoint]) async {
    if (e.response?.statusCode == 401 && _shouldHandleTokenExpiration(endpoint)) {
      await _authTokenService.handleTokenExpiration();
      return NetworkResponse(
        success: false,
        message: 'Session expired. Please login again.',
        data: null,
        statusCode: 401,
      );
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      logMessage(
        'ApiService',
        'Request timeout: ${e.type}. Consider increasing timeout values.',
      );
      return NetworkResponse(
        success: false,
        message:
            'Request timed out. Please check your internet connection and try again.',
        data: null,
        statusCode: 408,
      );
    }

    return NetworkResponse(
      success: false,
      message: e.message ?? 'An error occurred',
      data: null,
      statusCode: e.response?.statusCode,
    );
  }
}
