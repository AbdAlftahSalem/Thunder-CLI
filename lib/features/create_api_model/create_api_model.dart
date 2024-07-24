import 'package:thunder_cli/core/networking/dio_handler.dart';
import 'package:thunder_cli/features/create_api_model/setup_request_data.dart';

import '../../core/models/request_model.dart';
import 'build_model_file.dart';

class CreateApiModel {
  Future<void> createApiModel() async {
    // set up model file
    RequestModel requestModel = SetupRequestData.setupRequestData();

    DioHandler.safeApiCall(
      requestModel.url,
      requestModel.requestType ?? RequestType.get,
      headers: requestModel.headers,
      body: requestModel.body,
      queryParameters: requestModel.params,
      onSuccess: (res) {
        if (res.data is Map || res.data is List) {
          BuildModelFile.buildModelFile(
            requestModel: requestModel,
            data: res.data,
          );
        } else {
          print("Thunder can convert only Map or List !!");
        }
      },
    );
  }
}
