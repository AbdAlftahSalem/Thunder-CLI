import 'package:thunder_cli/core/models/request_model.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/extract_request_details.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/read_file_path_and_data.dart';

import '../../core/models/variable_model.dart';

class ConvertApiCollectionToCode {
  static void convertApiCollectionToCode() async {
    // read collection data
    Map<String, dynamic> collectionData =
        await ReadFilePathAndData.readFilePathAndData();

    // extract variables
    List<VariableModel> variablesModel =
        _getVariables(collectionData['variable']);

    // get all requests
    List<RequestModel> request = ExtractRequestDetails.extractRequestDetails(
      collectionData: collectionData,
      variablesModel: variablesModel,
    );
    print(request);
  }

  static List<VariableModel> _getVariables(List vars) {
    List<VariableModel> variablesModel = [];
    for (var i in vars) {
      variablesModel.add(VariableModel.fromMap(i));
    }

    return variablesModel;
  }
}
