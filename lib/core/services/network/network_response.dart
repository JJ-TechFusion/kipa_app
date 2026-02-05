class NetworkResponse {
  final String message;
  final bool success;
  final dynamic data;
  final int? statusCode;

  NetworkResponse({
    required this.message,
    required this.success,
    required this.data,
    this.statusCode,
  });

  factory NetworkResponse.fromMap(Map<String, dynamic> map) {
    return NetworkResponse(
      message: map['message'] ?? '',
      success: map['success'] ?? false,
      data: map['data'],
      statusCode: map['statusCode'],
    );
  }

  @override
  String toString() =>
      'NetworkResponse(message: $message, success: $success, data: $data, statusCode: $statusCode)';
}
