import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/models/request_model.dart';

import '../../core/consts/const_strings.dart';
import '../../core/consts/folder_paths.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';

class BuildRepoForRequests {
  // ToDo : need refactor
  static Future<void> buildRepoForRequests(List<RequestModel> requests) async {
    for (RequestModel request in requests) {
      String previousRepoData = await FolderAndFileService.readFile(
        FolderPaths.instance.repoFile(request.featureName),
      );
      String repoData = "";

      if (previousRepoData.isEmpty) {
        repoData = ConstStrings.instance.repo(
          request.featureName,
          requestType: request.requestType.toString().split(".").last,
          url: "ApiConstants.${request.varInDartFile}",
          repoParameter: request.body.isNotEmpty
              ? "${"${request.modelName}_body_model"} ${request.modelName.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}"
              : "",
        );
      } else {
        List<String?> importData = RegExp(r'import.*?;')
            .allMatches(previousRepoData)
            .map((e) => e.group(0))
            .toList();

        if (request.body.isNotEmpty) {
          importData
              .add("import '../models/${request.modelName}_body_model.dart';");
        }

        repoData = previousRepoData.replaceFirst("""
      }
    }""", "  }\n");

        repoData += """
      ${ConstStrings.instance.repoFunction(
          request.url,
          requestType: request.requestType.toString().split(".").last,
          url: "ApiConstants.${request.varInDartFile}",
          repoParameter: request.body.isNotEmpty
              ? "${"${request.modelName}_body_model"} ${request.modelName.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}"
              : "",
        )}
    }\n\n""";

        List<String> splitRepoData = repoData.split("\n");
        splitRepoData.removeWhere((element) => element.startsWith("import "));
        splitRepoData.insertAll(0, Iterable.castFrom(importData));

        repoData = splitRepoData.join("\n");
      }

      await FolderAndFileService.createFile(
        FolderPaths.instance.repoFile(request.featureName),
        repoData,
      );
    }
    print("✅ Build ${requests.length} repo`s successfully ...");
  }
}
