import 'package:thunder_cli/core/extensions/string_extensions.dart';

import '../../core/consts/const_strings.dart';
import '../../core/consts/folder_paths.dart';
import '../../core/models/request_model.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';

class BuildControllerForRequests {
  static Future<void> buildControllerForRequests(List<RequestModel> requests) async{
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
