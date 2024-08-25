import 'dart:convert';

import 'package:thunder_cli/core/networking/dio_handler.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/read_file_path_and_data.dart';

import '../../core/models/variable_model.dart';
import '../create_api_model/setup_request_data.dart';

class ConvertApiCollectionToCode {
  static void convertApiCollectionToCode() async {
    Map<String, dynamic> collectionData =
        await ReadFilePathAndData.readFilePathAndData();
    List<VariableModel> variablesModel =
        _getVariables(collectionData['variable']);
    VariableModel baseUrl = variablesModel.firstWhere(
        (element) => element.toString().toLowerCase().contains("url"));

    for (var folderCollection in collectionData['item']) {
      for (var requestInFolder in folderCollection['item']) {
        String requestName = requestInFolder['name'];
        RequestType requestType = SetupRequestData.getRequestType(
            requestInFolder['request']['method']);
        Map<String, dynamic> headers =
            getHeaders(requestInFolder['request']['header']);
        Map<String, dynamic> body = getBody(requestInFolder);
        String url = (requestInFolder['request']['url']['raw'])
            .toString()
            .replaceAll(baseUrl.key, baseUrl.value)
            .replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("//", "/");

        print(requestName);
        print(url);
        print(body);
        print("${"*" * 100}\n");
      }
    }
  }

  static Map<String, dynamic> getBody(requestInFolder) {
    Map<String, dynamic> body = {};
    if ((requestInFolder['request']['body']['raw']).toString().isNotEmpty &&
        (requestInFolder['request']['body'] as Map<String, dynamic>)
            .containsKey("raw")) {
      body = jsonDecode(requestInFolder['request']['body']['raw']);
    } else if ((requestInFolder['request']['body'] as Map<String, dynamic>)
        .containsKey("formdata")) {
      for (var i in requestInFolder['request']['body']['formdata']) {
        body.addAll({i['key']: i['type'] == "file" ? i['src'] : i['value']});
      }
    }
    return body;
  }

  static List<VariableModel> _getVariables(List vars) {
    List<VariableModel> variablesModel = [];
    for (var i in vars) {
      variablesModel.add(VariableModel.fromMap(i));
    }

    return variablesModel;
  }

  static Map<String, dynamic> getHeaders(List headersList) {
    Map<String, dynamic> headers = {};
    for (var i in headersList) {
      headers.addAll({i['key']: i["value"]});
    }
    return headers;
  }
}
