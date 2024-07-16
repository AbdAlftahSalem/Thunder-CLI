import 'dart:convert';
import 'dart:io';

import 'package:thunder_cli/extensions/string_extensions.dart';

import '../../data/network_data.dart';
import '../../models/request_model.dart';

class SetupRequestData {
  static RequestModel setupRequestData() {
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

    print(
        "Thunder is creating your model file . please wait for seconds 🔃\n\n\n");
    return requestModel;
  }

  static RequestType _getRequestType(String type) {
    type = type.toLowerCase();

    if (type == "get") {
      return RequestType.get;
    } else if (type == "post") {
      return RequestType.post;
    } else {
      return RequestType.get;
    }
  }
}
