import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/models/request_model.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/extract_request_details.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/get_variables_data.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/read_file_path_and_data.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/set_routes_in_api_const.dart';

import '../../core/consts/const_strings.dart';
import '../../core/consts/folder_paths.dart';
import '../../core/models/variable_model.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';
import './build_repos_for_requests.dart';
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

    // 2- build response model for every request
    // for (var element in requests) {
    //   await CreateApiModel().createApiModel(requestModelParameter: element);
    // }

    // 3- Build model for request has body
    BuildBodyModelFile.buildBodyModelFile(requests);
    print("\n⚡ Finish Build body models successfully 🎉 ...");

    // 4 - build repo for every request
    await BuildRepoForRequests.buildRepoForRequests(requests);

    // 5- Build controllers for all requests
    // create controller file
    for (var request in requests) {
      String name =
          "${request.requestType.toString().split(".").last}${request.modelName.toCamelCaseFirstLetterForEachWord()}Data";
      FolderAndFileService.createFile(
        FolderPaths.instance.controllerFile(request.featureName),
        ConstStrings.instance.controllerGetX(request.featureName,
            repoMethodName: name,
            bodyModel: request.body.isEmpty
                ? ""
                : "${request.featureName.toCamelCaseFirstLetterForEachWord()}BodyModel()"),
      ).then((value) => print("Finish build ${request.featureName} logic\n"));
    }
  }
}
