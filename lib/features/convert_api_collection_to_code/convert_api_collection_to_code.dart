import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/models/request_model.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/extract_request_details.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/get_variables_data.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/read_file_path_and_data.dart';
import 'package:thunder_cli/features/create_api_model/create_api_model.dart';

import '../../core/models/variable_model.dart';

class ConvertApiCollectionToCode {
  static void convertApiCollectionToCode() async {
    // read collection data
    Map<String, dynamic> collectionData =
        await ReadFilePathAndData.readFilePathAndData();

    // extract variables
    List<VariableModel> variablesModel =
        GetVariablesData.getVariables(collectionData['variable']);

    bool changeModelAndFeatureName = _checkChangeModelAndFeatureName();

    // get all requests
    List<RequestModel> request = ExtractRequestDetails.extractRequestDetails(
      collectionData: collectionData,
      variablesModel: variablesModel,
      inputNames: changeModelAndFeatureName,
    );

    for (var element in request) {
      await CreateApiModel().createApiModel(requestModelParameter: element);
    }
  }

  static bool _checkChangeModelAndFeatureName() {
    String choice = '';
    while (choice.isEmpty &&
        choice.toLowerCase() != 'n' &&
        choice.toLowerCase() != 'y') {
      stdout.write("Do you want change model or feature names ? [ y | N ] : ");
      choice = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage("😢 Choice cannot be empty !!");
    }
    return choice == 'y';
  }
}
