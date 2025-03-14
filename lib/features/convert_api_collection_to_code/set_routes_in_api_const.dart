import 'package:thunder_cli/core/consts/folder_paths.dart';
import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/models/request_model.dart';

class SetRoutesInApiConst {
  static Future<List<RequestModel>> setRoutesInApiConst(
      List<RequestModel> requests, String baseUrl) async {
    String routes = _setupAllRoutesDartFile(requests, baseUrl);

    String routesClass = "class ApiConstants {";
    routesClass += "\n$routes\n}";
    await FolderAndFileService.createFile(
      FolderPaths.instance.apiConstRoutesFile,
      routesClass,
    );

    for (var element in requests) {
      element.varInDartFile = _getVariableName(element.modelName);
    }

    return requests;
  }

  static String _getVariableName(String modelName) {
    return modelName.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter();
  }

  static String _getVariableValue(String url, String baseUrl) {
    String newUrl = url.replaceAll(baseUrl, "");
    // if (baseUrl.endsWith("/")) {
    //   newUrl = newUrl.replaceFirst("/", "");
    // }

    return newUrl.replaceFirst("/", "");
  }

  static String _setupAllRoutesDartFile(
      List<RequestModel> requests, String baseUrl) {
    String allRoutes = "static const baseUrl = '$baseUrl';\n";

    for (RequestModel value in requests) {
      String variableName = _getVariableName(value.modelName);
      String variableValue = _getVariableValue(value.url, baseUrl);

      allRoutes += "static const $variableName = '$variableValue';\n";
    }
    return allRoutes;
  }
}
