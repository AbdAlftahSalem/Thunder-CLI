import 'dart:convert';
import 'dart:io';

import 'package:thunder_cli/consts/folder_paths.dart';

import '../data/remote/base_client.dart';
import '../extensions/string_extensions.dart';
import '../services/create_folder_files.dart';

class CreateModels {
  Future<void> createModelFile() async {
    // set up model file
    var data = await _setupRequestData();

    if (data[0]) {
      print("Thunder is creating your model file . please wait for seconds 🔃");
      BaseClient.safeApiCall(
        data[1]["url"].trim(),
        data[1]["type"],
        headers: data[1]["headers"],
        data: data[1]["body"],
        queryParameters: data[1]["params"],
        onSuccess: (res) {
          if (res.data is Map || res.data is List) {
            CreateModels()._createModel(
              name: data[1]["name"],
              data: res.data,
            );
          } else {
            print("Thunder can convert only Map or List !!");
          }
        },
      );
    }
  }

  void _createModel({required String name, required dynamic data}) {
    // create model file
    CreateFolderAndFiles().createFile(
      FolderPaths.modelFile(name),
      _convertMapToClassModel(
        name: name,
        data: data is Map ? data : data[0],
      ),
    );

    print("⚡ Create model file successfully");
  }

  Future _setupRequestData() async {
    stdout.write(
        "Enter your model name [ user / product [ thunder will add 'model' keyword ] ] : ");
    final name = stdin.readLineSync();

    if (name == null || name.isEmpty) {
      print("Name name cannot be empty !!");
      return (false, null);
    }

    stdout.write("Enter type of request [ get / post ] : ");
    RequestType type = _getRequestType(stdin.readLineSync() ?? "");

    stdout.write("Enter your full url : ");
    final url = stdin.readLineSync();

    if (url == null || url.isEmpty) {
      print("Url cannot be empty !!");
      return [false, null];
    }

    stdout.write("Enter your request body : ");
    String bodyString = stdin.readLineSync() ?? "";
    Map<String, dynamic> body =
        bodyString.isEmpty ? {} : jsonDecode(bodyString);

    stdout.write("Enter your request headers : ");
    String headersString = stdin.readLineSync() ?? "";
    Map<String, dynamic> headers =
        headersString.isEmpty ? {} : jsonDecode(headersString);

    stdout.write("Enter your request params : ");
    String paramsString = stdin.readLineSync() ?? "";
    Map<String, dynamic> params =
        paramsString.isEmpty ? {} : jsonDecode(paramsString);

    return [
      true,
      {
        "name": name,
        "type": type,
        "url": url,
        "body": body,
        "headers": headers,
        "params": params,
      }
    ];
  }

  RequestType _getRequestType(String type) {
    if (type == "get") {
      return RequestType.get;
    } else if (type == "post") {
      return RequestType.post;
    } else {
      return RequestType.get;
    }
  }

  String _convertMapToClassModel({required String name, required Map data}) {
    String content = "class ${name.toCamelCase()}Model {\n";

    List<Map> mapKeys = [];

    // add variables
    data.forEach((key, value) {
      if (value is String) {
        content +=
            "  String? ${key.toString().toCamelCase().lowerCaseFirstLetter()};\n";
      } else if (value is int) {
        content +=
            "  int? ${key.toString().toCamelCase().lowerCaseFirstLetter()};\n";
      } else if (value is double) {
        content +=
            "  double? ${key.toString().toCamelCase().lowerCaseFirstLetter()};\n";
      } else if (value is bool) {
        content +=
            "  bool? ${key.toString().toCamelCase().lowerCaseFirstLetter()};\n";
      } else if (value is List) {
        if (value.isNotEmpty) {
          if (value[0] is Map) {
            content +=
                "  List<${key.toString().toCamelCase()}Model>? ${key.toString().toCamelCase().lowerCaseFirstLetter()};\n";
            mapKeys.add({key: value[0]});
          } else {
            content +=
                "  List<dynamic>? ${key.toString().toCamelCase().lowerCaseFirstLetter()};\n";
          }
        } else {
          content +=
              "  List<dynamic>? ${key.toString().toCamelCase().lowerCaseFirstLetter()};\n";
        }
      } else if (value is Map) {
        content +=
            "  ${key.toString().toCamelCase()}Model? ${key.toString().toCamelCase().lowerCaseFirstLetter()};\n";
        mapKeys.add({key: value});
      } else {
        content +=
            "  dynamic ${key.toString().toCamelCase().lowerCaseFirstLetter()};\n";
      }
    });

    // add optional constructor
    content += "\n  ${name.toCamelCase()}Model({\n";
    data.forEach((key, value) {
      content +=
          "    this.${key.toString().toCamelCase().lowerCaseFirstLetter()},\n";
    });
    content += "  });\n";

    // add fromJson method
    content +=
        "\n\n  ${name.toCamelCase()}Model.fromJson(Map<String, dynamic> json) {\n   ${name.toCamelCase()}Model(\n";
    data.forEach((key, value) {
      content +=
          "    ${key.toString().toCamelCase().lowerCaseFirstLetter()}: ${value is Map ? "${key.toString().toCamelCase()}Model.fromJson(json['$key'])," : "json['$key'],"}\n";
    });

    // add toJson method
    content += "  );\n}\n\n  Map<String, dynamic> toJson() {\n";
    content += "    final Map<String, dynamic> data =  <String, dynamic>{};\n";
    data.forEach((key, value) {
      content +=
          "    data['$key'] = ${key.toString().toCamelCase().lowerCaseFirstLetter()};\n";
    });
    content += "    return data;\n  }\n}\n\n";

    // add map keys
    for (var element in mapKeys) {
      element.forEach((key, value) {
        content += _convertMapToClassModel(name: key, data: value);
      });
    }

    return content;
  }
}
