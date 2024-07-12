import '../data/network_data.dart';

class RequestModel {
  String modelName, url;
  RequestType? requestType;
  Map<String, dynamic> body, headers, params;

  RequestModel({
    this.modelName = '',
    this.url = '',
    this.requestType,
    this.body = const {},
    this.headers = const {},
    this.params = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'modelName': modelName,
      'url': url,
      'requestType': requestType,
      'body': body,
      'headers': headers,
      'params': params,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      modelName: map['modelName'],
      url: map['url'],
      requestType: map['requestType'],
      body: map['body'],
      headers: map['headers'],
      params: map['params'],
    );
  }
}
