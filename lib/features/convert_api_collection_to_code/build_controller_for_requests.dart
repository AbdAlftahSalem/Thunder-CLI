import 'package:thunder_cli/core/consts/const_strings.dart';
import 'package:thunder_cli/core/consts/folder_paths.dart';
import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/models/request_model.dart';

class BuildControllerForRequests {
  static Future<void> buildControllerForRequests(
      List<RequestModel> requests) async {
    for (RequestModel request in requests) {
      String repoName =
          "${request.requestType.toString().split(".").last}${request.modelName.toCamelCaseFirstLetterForEachWord()}Data";
      FolderAndFileService.createFile(
        FolderPaths.instance.controllerFile(request.featureName),
        ConstStrings.instance.controllerGetX(request.featureName,
            repoMethodName: repoName,
            bodyModel: request.body.isEmpty
                ? ""
                : "${request.featureName.toCamelCaseFirstLetterForEachWord()}BodyModel()"),
      );
    }
  }
}
