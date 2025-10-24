class ApiResponse<T> {
  final List<dynamic> errors;
  final bool isSuccessful;
  final bool isDBAccessible;
  final T? result;
  final String message;
  final int statusCode;

  ApiResponse({
    required this.errors,
    required this.isSuccessful,
    required this.isDBAccessible,
    this.result,
    required this.message,
    required this.statusCode,
  });

  /// Factory constructor to create ApiResponse from JSON
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      errors: json['errors'] ?? [],
      isSuccessful: json['isSuccessful'] ?? false,
      isDBAccessible: json['isDBAccessible'] ?? false,
      result: json['result'],
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
    );
  }

  /// Convert ApiResponse back to JSON
  Map<String, dynamic> toJson() {
    return {
      'errors': errors,
      'isSuccessful': isSuccessful,
      'isDBAccessible': isDBAccessible,
      'result': result,
      'message': message,
      'statusCode': statusCode,
    };
  }
}
