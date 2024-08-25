import 'package:thunder_cli/features/convert_api_collection_to_code/read_file_path_and_data.dart';

import '../../core/models/variable_model.dart';

class ConvertApiCollectionToCode {
  static void convertApiCollectionToCode() async {
    Map<String, dynamic> collectionData =
        await ReadFilePathAndData.readFilePathAndData();
    List<VariableModel> variablesModel =
        _getVariables(collectionData['variable']);
    print(variablesModel);
  }

  static List<VariableModel> _getVariables(List vars) {
    List<VariableModel> variablesModel = [];
    for (var i in vars) {
      variablesModel.add(VariableModel.fromMap(i));
    }

    return variablesModel;
  }
}
