import 'dart:convert';
import 'dart:io';

import 'package:thunder_cli/consts/folder_paths.dart';

import '../data/network_data.dart';
import '../extensions/string_extensions.dart';
import '../models/request_model.dart';
import '../services/create_folder_files.dart';

class CreateApiModel {
  Future<void> createModelFile() async {
    // set up model file
    RequestModel requestModel = await _setupRequestData();

    print(
        "Thunder is creating your model file . please wait for seconds 🔃\n\n\n");
    BaseClient.safeApiCall(
      requestModel.url,
      requestModel.requestType ?? RequestType.get,
      headers: requestModel.headers,
      body: requestModel.body,
      queryParameters: requestModel.params,
      onSuccess: (res) {
        if (res.data is Map || res.data is List) {
          CreateApiModel()._createModel(
            modelName: requestModel.modelName,
            data: res.data,
          );
        } else {
          print("Thunder can convert only Map or List !!");
        }
      },
    );
  }

  void _createModel({required String modelName, required dynamic data}) {
    // create model file
    CreateFolderAndFiles().createFile(
      FolderPaths.instance.modelFile(modelName),
      _convertMapToClassModel(
        name: modelName,
        data: data is Map ? data : data[0],
      ),
    );

    print("⚡ Create model file successfully\n\n");
  }

  Future<RequestModel> _setupRequestData() async {
    RequestModel requestModel = RequestModel();

    while (requestModel.modelName.isEmpty) {
      stdout.write(
          "Enter your model name [ user / product [ thunder will add 'model' keyword by default ] ] : ");
      requestModel.modelName = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndShowMessage("😢 Model Name name cannot be empty !!");
    }

    while (requestModel.requestType == null) {
      stdout.write("Enter type of request [ get / post ] : ");
      requestModel.requestType = _getRequestType(stdin.readLineSync() ?? "");
      print("✅ Request type is : ${requestModel.requestType}");
    }

    while (requestModel.url.isEmpty) {
      stdout.write("Enter your full url : ");
      requestModel.url = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndShowMessage(" Url cannot be empty !!");
    }

    stdout.write("Enter your request body : ");
    String bodyString = stdin.readLineSync() ?? "";
    requestModel.body = bodyString.isEmpty ? {} : jsonDecode(bodyString);

    stdout.write("Enter your request headers : ");
    String headersString = stdin.readLineSync() ?? "";
    requestModel.headers =
        headersString.isEmpty ? {} : jsonDecode(headersString);

    stdout.write("Enter your request params : ");
    String paramsString = stdin.readLineSync() ?? "";
    requestModel.params = paramsString.isEmpty ? {} : jsonDecode(paramsString);

    return requestModel;
  }

  RequestType _getRequestType(String type) {
    type = type.toLowerCase();

    if (type == "get") {
      return RequestType.get;
    } else if (type == "post") {
      return RequestType.post;
    } else {
      return RequestType.get;
    }
  }

  String _convertMapToClassModel({required String name, required Map data}) {
    String content = "class ${name.toCamelCaseFirstLetter()}Model {\n";

    List<Map> mapKeys = [];

    // add variables
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

    // add optional constructor
    content += "\n  ${name.toCamelCaseFirstLetter()}Model({\n";
    data.forEach((key, value) {
      content +=
          "    this.${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()},\n";
    });
    content += "  });\n";

    // add fromJson method
    content +=
        "\n\n  ${name.toCamelCaseFirstLetter()}Model.fromJson(Map<String, dynamic> json) {\n   ${name.toCamelCaseFirstLetter()}Model(\n";
    data.forEach((key, value) {
      content +=
          "    ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()}: ${value is Map ? "${key.toString().toCamelCaseFirstLetter()}Model.fromJson(json['$key'])," : "json['$key'],"}\n";
    });

    // add toJson method
    content += "  );\n}\n\n  Map<String, dynamic> toJson() {\n";
    content += "    final Map<String, dynamic> data =  <String, dynamic>{};\n";
    data.forEach((key, value) {
      content +=
          "    data['$key'] = ${key.toString().toCamelCaseFirstLetter().lowerCaseFirstLetter()};\n";
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
