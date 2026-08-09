import '../failures/failure.dart';

class ApiResponse {
  final dynamic body;

  final bool isSuccess;
  final int statusCode;

  final String? errorMessage;
  final Failure? failure;

  ApiResponse({
    required this.body,
    required this.isSuccess,
    required this.statusCode,
    this.errorMessage,
    this.failure,
  });

  bool get isMap => body is Map<String, dynamic>;

  bool get isList => body is List;

  Map<String, dynamic>? get map =>
      body is Map<String, dynamic> ? body as Map<String, dynamic> : null;

  List<dynamic>? get list =>
      body is List ? body as List<dynamic> : null;
}