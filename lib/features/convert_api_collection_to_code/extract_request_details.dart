import 'dart:convert';
import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/networking/dio_handler.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/models/request_model.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/models/variable_model.dart';
import 'package:thunder_cli/features/create_api_model/setup_request_data.dart';

class ExtractRequestDetails {
  static List<RequestModel> extractRequestDetails({
    required Map<String, dynamic> collectionData,
    required List<VariableModel> variablesModel,
  }) {
    List<RequestModel> requests = [];

    VariableModel baseUrl = variablesModel
        .where((element) => element.toString().toLowerCase().contains("url"))
        .first;

    stdout.write(
        "\n\nDo you want change feature or model name ? [ y | N ] ( Default N ) : ");
    String changeRepoAndFeatureName = (stdin.readLineSync() ?? "n");

    print(changeRepoAndFeatureName);
    for (Map folderCollection in collectionData['item']) {
      if (!(folderCollection.containsKey("item"))) {
        RequestModel requestModel = getDetailOfRequest(
            folderCollection,
            baseUrl,
            variablesModel,
            changeRepoAndFeatureName.toLowerCase() == 'y');
        requests.add(requestModel);
      } else {
        for (var requestInFolder in folderCollection['item']) {
          print(requestInFolder);
          RequestModel requestModel = getDetailOfRequest(
              requestInFolder,
              baseUrl,
              variablesModel,
              changeRepoAndFeatureName.toLowerCase() == 'y');
          requests.add(requestModel);
        }
      }
    }
    if (requests.isNotEmpty) {
      for (int i = 0; i < requests.length; ++i) {
        print(
            "${i + 1 < 10 ? "0" : ""}${i + 1} - Feature : ${requests[i].featureName} || Model : ${requests[i].modelName}");
        print("   - URL :${requests[i].url}");
        print(
            "   - Request method : ${requests[i].requestType.toString().split(".")[1].toUpperCase()}\n");
      }
    }
    return requests;
  }

  static RequestModel getDetailOfRequest(requestInFolder, VariableModel baseUrl,
      List<VariableModel> variablesModel, bool changeRepoAndFeatureName) {
    String modelName = "";
    String featureName = "";

    String requestName = requestInFolder['name'];

    // get request type
    RequestType requestType =
        SetupRequestData.getRequestType(requestInFolder['request']['method']);

    // get header
    Map<String, dynamic> headers =
        _getHeaders(requestInFolder['request']['header'], variablesModel);

    // get body
    Map<String, dynamic> body = _getBody(requestInFolder, variablesModel);

    // get auth if found
    if (requestInFolder['request'].containsKey("auth")) {
      String authType = requestInFolder['request']['auth']['type'];
      if (requestInFolder['request']['auth'].containsKey(authType)) {
        if ((requestInFolder['request']['auth'][authType] as List).isNotEmpty) {
          String token = requestInFolder['request']['auth'][authType][0]
                  ['value']
              .toString()
              .convertVariableToValue(variablesModel);
          headers.addAll({"Authorization": "$authType $token"});
        }
      }
    }

    // get url
    String url = (requestInFolder['request']['url']['raw'])
        .toString()
        .replaceAll(baseUrl.key, baseUrl.value.updateSlashInUrl())
        .replaceAll("{", "")
        .replaceAll("}", "");

    if (changeRepoAndFeatureName) {
      print("\nRoute : $url");
      print("Current model and feature name : $requestName");
      stdout.write("Enter new model name [ By default $requestName ] : ");
      modelName = stdin.readLineSync() ?? requestName;
      modelName = modelName.isEmpty ? requestName : modelName;

      stdout.write("Enter new feature name [ By default $modelName ] : ");
      featureName = stdin.readLineSync() ?? requestName;
      featureName = featureName.isEmpty ? modelName : featureName;
    }

    // setup final request
    RequestModel requestModel = RequestModel(
      body: body,
      headers: headers,
      url: url,
      requestType: requestType,
      params: {},
      modelName: (modelName.isEmpty ? requestName : modelName)
          .toLowerCase()
          .replaceAll(" ", "_")
          .replaceAll("-", "_"),
      featureName: (featureName.isEmpty ? requestName : featureName)
          .toLowerCase()
          .replaceAll(" ", "_")
        ..replaceAll("-", "_"),
    );
    return requestModel;
  }

  static Map<String, dynamic> _getBody(Map<String, dynamic> requestInFolder,
      List<VariableModel> variablesModel) {
    Map<String, dynamic> body = {};
    if (requestInFolder['request'].containsKey("body")) {
      if ((requestInFolder['request']['body']['raw']).toString().isNotEmpty &&
          (requestInFolder['request']['body'] as Map<String, dynamic>)
              .containsKey("raw")) {
        body = jsonDecode(requestInFolder['request']['body']['raw']);
      } else if ((requestInFolder['request']['body'] as Map<String, dynamic>)
          .containsKey("formdata")) {
        for (var i in requestInFolder['request']['body']['formdata']) {
          body.addAll({
            i['key']: i['type'] == "file"
                ? i['src']
                : i['value'].toString().convertVariableToValue(variablesModel)
          });
        }
      }
    }
    return body;
  }

  static Map<String, dynamic> _getHeaders(
      List headersList, List<VariableModel> variablesModel) {
    Map<String, dynamic> headers = {};
    for (var i in headersList) {
      headers.addAll({
        i['key']: i["value"].toString().convertVariableToValue(variablesModel)
      });
    }
    return headers;
  }
}
