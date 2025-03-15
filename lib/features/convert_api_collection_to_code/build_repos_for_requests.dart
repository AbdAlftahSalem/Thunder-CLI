import 'package:thunder_cli/core/consts/const_strings.dart';
import 'package:thunder_cli/core/consts/folder_paths.dart';
import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/models/request_model.dart';

class BuildRepoForRequests {
  static Future<void> buildRepoForRequests(List<RequestModel> requests) async {
    Map<String, List<RequestModel>> requestsByFolder = {};

    // Group requests by featureName (folder)
    for (RequestModel request in requests) {
      requestsByFolder.putIfAbsent(request.repoName, () => []).add(request);
    }

    // Generate a repository class for each folder
    for (var folderName in requestsByFolder.keys) {
      List<RequestModel> folderRequests = requestsByFolder[folderName]!;

      String className =
          "${folderName.toCamelCaseFirstLetterForEachWord()}Repo";
      List<String> importData = [
        "import '../../core/networking/api_result.dart';"
            "import '../../core/networking/base_client.dart';"
            "import '../../core/networking/enums_networking.dart';"
            "import '../../helper/constants/api_constants.dart';"
      ];

      String repoFunctions = "";

      for (RequestModel request in folderRequests) {
        if (request.body.isNotEmpty) {
          String modelImport =
              "import '../models/${request.modelName}_body_model.dart';";
          if (!importData.contains(modelImport)) {
            importData.add(modelImport);
          }
        }

        repoFunctions += ConstStrings.instance.repoFunction(
          request.url.split("/").last.replaceAll("ApiConstants.", ""),
          requestType: request.requestType.toString().split(".").last,
          url: "ApiConstants.${request.varInDartFile}",
          repoParameter: request.body.isNotEmpty
              ? "${"${request.modelName}_body_model"} ${request.modelName.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}"
              : "",
        );
        repoFunctions += "\n\n";
      }

      // Generate the full class
      String repoClass = """
${importData.join("\n")}

class $className {
  DioHelper dioHelper;

  $className(this.dioHelper);

  $repoFunctions
}
""";

      // Write to file
      await FolderAndFileService.createFile(
        FolderPaths.instance.repoFile(folderName),
        repoClass,
      );
    }
  }
}
