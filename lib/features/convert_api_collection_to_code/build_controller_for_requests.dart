import 'package:thunder_cli/core/consts/folder_paths.dart';
import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/models/request_model.dart';

class BuildControllerForRequests {
  static Future<void> buildControllersForRequests(
      List<RequestModel> requests) async {
    // Group requests by feature
    Map<String, List<RequestModel>> groupedRequests = {};

    for (var request in requests) {
      groupedRequests.putIfAbsent(request.repoName, () => []).add(request);
    }

    // Generate controllers for each feature
    for (var feature in groupedRequests.keys) {
      List<RequestModel> featureRequests = groupedRequests[feature]!;
      String controllerName =
          "${feature.toCamelCaseFirstLetterForEachWord()}Controller";
      String repoName = "${feature.toCamelCaseFirstLetterForEachWord()}Repo";

      // Generate the controller file content
      String controllerData = '''
import 'package:get/get.dart';
import '../../../core/networking/api_result.dart';
import '../../../core/networking/enums_networking.dart';
import '../repositories/${feature.toLowerCase()}_repo.dart';

class $controllerName extends GetxController {
  final $repoName ${repoName.lowerCaseFirstLetter()};
  
  $controllerName({required this.${repoName.lowerCaseFirstLetter()}});
  
  ApiResult apiResult = ApiResult();
  
${featureRequests.map((request) {
        String functionName =
            "${request.requestType.toString().split('.').last}${request.modelName}Data";
        String bodyModel = request.body.isNotEmpty
            ? "${request.modelName}_body_model ${request.modelName.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}"
            : "";

        return '''
  Future<void> $functionName($bodyModel) async {
    apiResult.apiCallStatus = ApiCallStatus.loading;
    update();

    apiResult = await ${repoName.lowerCaseFirstLetter()}.${functionName.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter().replaceAll("Data", "")}(${bodyModel.toCamelCaseFirstLetterForEachWord()});
    
    apiResult.handelRequest(
      success: (apiResul) {
        // Handle success response
      }, 
      error: (apiResul) {
        // Handle error response
      }
    );

    update();
  }
''';
      }).join("\n")}
  
  @override
  void onInit() {
    super.onInit();
  }
}
''';

      // Save the controller file
      await FolderAndFileService.createFile(
        FolderPaths.instance.controllerFile(feature),
        controllerData,
      );
    }
  }
}
