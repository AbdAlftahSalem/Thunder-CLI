import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/models/request_model.dart';

import '../../core/consts/const_strings.dart';
import '../../core/consts/folder_paths.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';

class BuildRepoForRequests {
  static void buildRepoForRequests(List<RequestModel> request) async {
    for (var request in request) {
      await FolderAndFileService.createFile(
        FolderPaths.instance.repoFile(request.featureName),
        ConstStrings.instance.repo(
          request.modelName,
          requestType: request.requestType.toString().split(".").last,
          url: "ApiConstants.${request.varInDartFile}",
          repoParameter: request.body.isNotEmpty
              ? "${"${request.modelName}_body_model"} login"
              : "",
        ),
      );
      print("\n✅ Build ${request.modelName} Repo successfully ...");
    }
  }
}
