import 'package:thunder_cli/features/create_api_model/setup_request_data.dart';

import '../../data/network_data.dart';
import '../../models/request_model.dart';
import 'build_model_file.dart';

class CreateApiModel {
  Future<void> createApiModel() async {
    // set up model file
    RequestModel requestModel = SetupRequestData.setupRequestData();

    BaseClient.safeApiCall(
      requestModel.url,
      requestModel.requestType ?? RequestType.get,
      headers: requestModel.headers,
      body: requestModel.body,
      queryParameters: requestModel.params,
      onSuccess: (res) {
        if (res.data is Map || res.data is List) {
          BuildModelFile.buildModelFile(
            modelName: requestModel.modelName,
            data: res.data,
          );
        } else {
          print("Thunder can convert only Map or List !!");
        }
      },
    );
  }
}
