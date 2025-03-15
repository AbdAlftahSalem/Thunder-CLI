import 'package:thunder_cli/core/networking/dio_handler.dart';

class RequestModel {
  String modelName, featureName, url, varInDartFile, repoName;
  RequestType? requestType;
  Map<String, dynamic> body, headers, params;

  RequestModel({
    this.modelName = '',
    this.featureName = '',
    this.url = '',
    this.varInDartFile = '',
    this.repoName = '',
    this.requestType,
    this.body = const {},
    this.headers = const {},
    this.params = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'modelName': modelName,
      'url': url,
      'varInDartFile': varInDartFile,
      'requestType': requestType,
      'body': body,
      'headers': headers,
      'params': params,
      'featureName': featureName,
      'repoName': repoName,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      modelName: map['modelName'],
      url: map['url'],
      varInDartFile: map['varInDartFile'],
      requestType: map['requestType'],
      body: map['body'],
      headers: map['headers'],
      params: map['params'],
      featureName: map['featureName'],
      repoName: map['repoName'],
    );
  }

  @override
  String toString() {
    return 'RequestModel{modelName: $modelName, featureName: $featureName, url: $url, requestType: $requestType, body: $body, headers: $headers, params: $params}';
  }
}
