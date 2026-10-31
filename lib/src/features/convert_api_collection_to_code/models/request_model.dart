import '../../../core/networking/dio_handler.dart';

/// One request read from a Postman collection.
class RequestModel {
  /// Request name in snake_case (`get_user`).
  String name;

  /// Group (top-level folder) in snake_case. One repository and one
  /// controller are generated per group.
  String group;

  /// HTTP method.
  RequestType requestType;

  /// Path relative to the base URL with `{param}` placeholders
  /// (`users/{id}`), or a full URL when the request uses another host.
  String path;

  /// Names of the `{param}` placeholders in [path].
  List<String> pathParams;

  /// Query parameter names found in the collection (documentation only).
  List<String> queryParams;

  /// Decoded JSON (or form) body, `null` when the request has no body.
  dynamic body;

  /// `true` when the body is `form-data` (sent as `FormData`).
  bool isFormData;

  /// First saved example response that is valid JSON, if any.
  dynamic responseExample;

  /// Name of the constant in `ApiConstants` (set by the generator).
  String constantName;

  /// Creates a request.
  RequestModel({
    required this.name,
    required this.group,
    required this.requestType,
    required this.path,
    this.pathParams = const [],
    this.queryParams = const [],
    this.body,
    this.isFormData = false,
    this.responseExample,
    this.constantName = '',
  });

  /// `true` when a body model can be generated (the body is a JSON object).
  bool get hasBodyModel => body is Map && (body as Map).isNotEmpty;

  @override
  String toString() =>
      'RequestModel{${requestType.name.toUpperCase()} $path, name: $name, group: $group}';
}
