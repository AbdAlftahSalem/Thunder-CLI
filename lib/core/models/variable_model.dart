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

  @override
  String toString() {
    return 'VariableModel{key: $key, value: $value}';
  }
}
