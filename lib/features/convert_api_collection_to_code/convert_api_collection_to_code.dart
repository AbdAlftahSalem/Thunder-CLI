import 'package:thunder_cli/core/models/request_model.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/extract_request_details.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/get_variables_data.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/read_file_path_and_data.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/set_routes_in_api_const.dart';
import 'package:thunder_cli/features/create_api_model/build_model_file.dart';

import '../../core/models/variable_model.dart';
import '../create_api_model/create_api_model.dart';
import 'build_body_model_file.dart';

class ConvertApiCollectionToCode {
  static void convertApiCollectionToCode() async {
    // read collection data
    Map<String, dynamic> collectionData =
        await ReadFilePathAndData.readFilePathAndData();

    // extract variables
    List<VariableModel> variablesModel =
        GetVariablesData.getVariables(collectionData['variable']);

    // get all requests
    List<RequestModel> requests = ExtractRequestDetails.extractRequestDetails(
      collectionData: collectionData,
      variablesModel: variablesModel,
    );

    // 1- set routes in const API file
    requests = await SetRoutesInApiConst.setRoutesInApiConst(
      requests,
      variablesModel
          .firstWhere((element) => element.key.toLowerCase().contains("url"))
          .value,
    );

    // 2- build model for every request
    for (var element in requests) {
      await CreateApiModel().createApiModel(requestModelParameter: element);
    }

    // 3- Build model for request has body
    BuildBodyModelFile.buildBodyModelFile(requests);
    print("\n⚡ Finish Build body models successfully 🎉 ...");
  }
}
