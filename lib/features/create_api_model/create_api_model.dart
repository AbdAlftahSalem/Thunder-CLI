import 'package:thunder_cli/core/networking/dio_handler.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/models/request_model.dart';
import 'package:thunder_cli/features/create_api_model/build_model_file.dart';
import 'package:thunder_cli/features/create_api_model/setup_request_data.dart';

class CreateApiModel {
  static Future<void> createApiModel(
      {RequestModel? requestModelParameter}) async {
    /// set up model file
    RequestModel? requestModel;
    if (requestModelParameter == null) {
      requestModel = SetupRequestData.setupRequestData();
    } else {
      requestModel = requestModelParameter;
    }

    DioHandler.safeApiCall(
      requestModel.url,
      requestModel.requestType ?? RequestType.get,
      headers: requestModel.headers,
      body: requestModel.body,
      queryParameters: requestModel.params,
      onSuccess: (res) {
        if (res.data is Map || res.data is List) {
          BuildModelFile.buildModelFile(
            requestModel: requestModel!,
            response: res.data,
          );
        } else {
          print("Thunder can convert only Map or List !!");
        }
      },
    );
  }
}
