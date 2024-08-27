import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/models/request_model.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/extract_request_details.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/get_variables_data.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/read_file_path_and_data.dart';

import '../../core/models/variable_model.dart';

class ConvertApiCollectionToCode {
  static void convertApiCollectionToCode() async {
    // read collection data
    Map<String, dynamic> collectionData =
        await ReadFilePathAndData.readFilePathAndData();

    // extract variables
    List<VariableModel> variablesModel =
        GetVariablesData.getVariables(collectionData['variable']);

    // get all requests
    List<RequestModel> request = ExtractRequestDetails.extractRequestDetails(
      collectionData: collectionData,
      variablesModel: variablesModel,
    );
    _check(variablesModel);
  }

  static void _check(List<VariableModel> s) {
    String deleteChoice = "";
    String deleteNumbers = "";
    List<int> deletedChoiceNumbers = [];
    while (deleteChoice.isEmpty &&
        deleteChoice.toLowerCase() != "n" &&
        deleteChoice.toLowerCase() != "y") {
      stdout.write("\nDo you want delete any request of them ? [ y | N ] : ");
      deleteChoice = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage("😢 Choice cannot be empty !!");
      if (deleteChoice.toLowerCase() != "y" &&
          deleteChoice.toLowerCase() != 'n') {
        print("❌ Choice must by in [ y | N]");
      }
    }

    if (deleteChoice.toLowerCase() == 'y') {
      while (deleteNumbers.isEmpty &&
          deleteNumbers.toString() != 'n' &&
          deleteNumbers.toString() != 'y') {
        stdout.write(
            "\nWrite number of requests to delete , you show separate between numbers by ',' : ");
        deleteNumbers = (stdin.readLineSync() ?? "")
            .trim()
            .checkIfEmptyAndNullAndShowMessage("😢 Numbers cannot be empty !!");

        // TODO : ERROR HERE
        deletedChoiceNumbers = deleteNumbers.split(",").cast<int>();
        if (deletedChoiceNumbers.isEmpty) {
          print("cannot delete empty numbers");
          deleteChoice = '';
        }
      }
    }
    print(deletedChoiceNumbers);
  }
}
