class VariableModel {
  String key;
  String value;

  VariableModel({
    required this.key,
    required this.value,
  });

  factory VariableModel.fromMap(Map<String, dynamic> map) {
    return VariableModel(
      key: map['key'].toString(),
      value: map['value'].toString(),
    );
  }

  factory VariableModel.defaultBaseUrl() {
    return VariableModel(
      key: "base_url",
      value: "http://localhost:8000",
    );
  }

  @override
  String toString() {
    return 'VariableModel{key: $key, value: $value}';
  }
}
