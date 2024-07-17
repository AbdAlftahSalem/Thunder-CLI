import 'package:thunder_cli/core/helper/extensions/string_extensions.dart';

class SetupHelperMethods {
  static String setupToJson({
    required String content,
    required Map<dynamic, dynamic> data,
  }) {
    content += "  );\n}\n\n  Map<String, dynamic> toJson() {\n";
    content += "    final Map<String, dynamic> data =  <String, dynamic>{};\n";
    data.forEach((key, value) {
      content +=
          "    data['$key'] = ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
    });
    content += "    return data;\n  }\n}\n\n";
    return content;
  }

  static String setupFromJson({
    required String content,
    required String name,
    required Map<dynamic, dynamic> data,
  }) {
    content +=
        "\n\n  ${name.toCamelCaseFirstLetter()}Model.fromJson(Map<String, dynamic> json) {\n   ${name.toCamelCaseFirstLetter()}Model(\n";
    data.forEach((key, value) {
      content +=
          "    ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()}: ${value is Map ? "${key.toString().toCamelCaseFirstLetter()}Model.fromJson(json['$key'])," : "json['$key'],"}\n";
    });
    return content;
  }

  static String setupOptionalConstructor({
    required String content,
    required String name,
    required Map<dynamic, dynamic> data,
  }) {
    content += "\n  ${name.toCamelCaseFirstLetter()}Model({\n";
    data.forEach((key, value) {
      content +=
          "    this.${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()},\n";
    });
    content += "  });\n";
    return content;
  }

  static String setupVariables({
    required Map<dynamic, dynamic> data,
    required String content,
    required List<Map<dynamic, dynamic>> mapKeys,
  }) {
    data.forEach((key, value) {
      if (value is String) {
        content +=
            "  String? ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
      } else if (value is int) {
        content +=
            "  int? ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
      } else if (value is double) {
        content +=
            "  double? ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
      } else if (value is bool) {
        content +=
            "  bool? ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
      } else if (value is List) {
        if (value.isNotEmpty) {
          if (value[0] is Map) {
            content +=
                "  List<${key.toString().toCamelCaseFirstLetter()}Model>? ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
            mapKeys.add({key: value[0]});
          } else {
            content +=
                "  List<dynamic>? ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
          }
        } else {
          content +=
              "  List<dynamic>? ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
        }
      } else if (value is Map) {
        content +=
            "  ${key.toString().toCamelCaseFirstLetter()}Model? ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
        mapKeys.add({key: value});
      } else {
        content +=
            "  dynamic ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
      }
    });
    return content;
  }
}
