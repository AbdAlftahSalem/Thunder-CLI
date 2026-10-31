/// A Postman collection variable (`{{key}}` => value).
class VariableModel {
  /// The variable name, without the curly braces.
  String key;

  /// The variable value.
  String value;

  /// Creates a variable.
  VariableModel({
    required this.key,
    required this.value,
  });

  /// Reads a variable from the collection's `variable` list.
  factory VariableModel.fromMap(Map<String, dynamic> map) {
    return VariableModel(
      key: (map['key'] ?? '').toString(),
      value: (map['value'] ?? '').toString(),
    );
  }

  /// The base URL used when a collection does not define one.
  factory VariableModel.defaultBaseUrl() {
    return VariableModel(
      key: "base_url",
      value: "http://localhost:8000/",
    );
  }

  @override
  String toString() {
    return 'VariableModel{key: $key, value: $value}';
  }
}
