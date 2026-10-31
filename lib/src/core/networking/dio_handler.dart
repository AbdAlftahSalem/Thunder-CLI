import 'package:dio/dio.dart';

/// HTTP methods Thunder can call when it builds a model from a URL.
enum RequestType {
  get,
  post,
  put,
  patch,
  delete;

  /// Parses `get`, `POST` ... Returns `null` for unknown values.
  static RequestType? tryParse(String value) {
    for (final type in values) {
      if (type.name == value.trim().toLowerCase()) return type;
    }
    return null;
  }
}

/// Calls an API so Thunder can read the JSON response.
class DioHandler {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  /// Performs the request and returns the decoded response body.
  /// Throws a readable [Exception] when the request fails.
  static Future<dynamic> request(
    String url,
    RequestType requestType, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Object? body,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          method: requestType.name.toUpperCase(),
          headers: headers,
          responseType: ResponseType.json,
        ),
      );
      return response.data;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      throw Exception(
          'Request failed${status == null ? '' : ' with status $status'}: ${e.message ?? e.type.name}');
    }
  }
}
