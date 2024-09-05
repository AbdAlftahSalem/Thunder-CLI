import 'dart:convert';
import 'dart:io';
import 'package:thunder_cli/core/extensions/string_extensions.dart';

import '../../core/models/request_model.dart';
import '../../core/networking/dio_handler.dart';

class SetupRequestData {
  static RequestModel setupRequestData() {
    RequestModel requestModel = RequestModel();

    while (requestModel.featureName.isEmpty) {
      stdout.write("Enter your feature name : ");
      requestModel.featureName = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage(
              "😢 Feature name cannot be empty !!");
    }

    while (requestModel.modelName.isEmpty) {
      stdout.write(
          "Enter your model name [ thunder will add 'model' keyword by default ] : ");
      requestModel.modelName = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage(
              "😢 Model Name name cannot be empty !!")
          .replaceAll("model", "");
    }

    while (requestModel.requestType == null) {
      stdout.write("Enter type of request [ get / post / put / delete ] : ");
      requestModel.requestType = getRequestType(stdin.readLineSync() ?? "");
    }

    while (requestModel.url.isEmpty) {
      stdout.write("Enter your full url : ");
      requestModel.url = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage(" Url cannot be empty !!");
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

    print(
        "Thunder is creating your model file . please wait for seconds 🔃\n\n\n");
    return requestModel;
  }

  static RequestType getRequestType(String type) {
    type = type.toLowerCase();

    switch (type) {
      case 'get':
        return RequestType.get;
      case 'post':
        return RequestType.post;
      case 'put':
        return RequestType.put;
      case 'delete':
        return RequestType.delete;
    }
    print(
        "❌ $type is not in [ get / post / put / delete ] . \nThe default type is Get");
    return RequestType.get;
  }
}
