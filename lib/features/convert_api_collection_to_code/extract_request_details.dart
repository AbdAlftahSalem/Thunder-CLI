import 'dart:convert';

import '../../core/models/request_model.dart';
import '../../core/models/variable_model.dart';
import '../../core/networking/dio_handler.dart';
import '../create_api_model/setup_request_data.dart';

class ExtractRequestDetails {
  static List<RequestModel> extractRequestDetails(
      {required Map<String, dynamic> collectionData,
        required List<VariableModel> variablesModel}) {
    List<RequestModel> requests = [];
    VariableModel baseUrl = variablesModel.firstWhere(
        (element) => element.toString().toLowerCase().contains("url"));

    for (var folderCollection in collectionData['item']) {
      for (var requestInFolder in folderCollection['item']) {
        String requestName = requestInFolder['name'];
        RequestType requestType = SetupRequestData.getRequestType(
            requestInFolder['request']['method']);
        Map<String, dynamic> headers =
            _getHeaders(requestInFolder['request']['header']);
        Map<String, dynamic> body = _getBody(requestInFolder);
        String url = (requestInFolder['request']['url']['raw'])
            .toString()
            .replaceAll(baseUrl.key, baseUrl.value)
            .replaceAll("{", "")
            .replaceAll("}", "")
            .replaceAll("//", "/");

        RequestModel requestModel = RequestModel(
          body: body,
          headers: headers,
          url: url,
          requestType: requestType,
          params: {},
          modelName: requestName.toString().toLowerCase(),
          featureName: requestName
              .toString()
              .toLowerCase()
              .replaceAll(" ", "_"),
        );
        requests.add(requestModel);
      }
    }
    return requests;
  }

  static Map<String, dynamic> _getBody(requestInFolder) {
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

  static Map<String, dynamic> _getHeaders(List headersList) {
    Map<String, dynamic> headers = {};
    for (var i in headersList) {
      headers.addAll({i['key']: i["value"]});
    }
    return headers;
  }
}
