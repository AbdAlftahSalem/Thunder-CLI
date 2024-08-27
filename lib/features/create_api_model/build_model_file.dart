import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/models/request_model.dart';
import 'package:thunder_cli/features/create_api_model/setup_helper_methods.dart';

import '../../core/consts/folder_paths.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';

class BuildModelFile {
  /// create model file using [requestModel] and [response]
  static Future<void> buildModelFile({
    required RequestModel requestModel,
    required dynamic response,
  }) async {
    await FolderAndFileService.createFile(
      FolderPaths.instance
          .modelFile(requestModel.modelName, requestModel.featureName),
      _convertMapToClassModel(
        name: requestModel.modelName,
        response: response is Map ? response : response[0],
      ),
    );

    print("⚡ Create ${requestModel.modelName} file successfully ...\n\n");
  }

  /// convert API [response] to model class
  static String _convertMapToClassModel({
    required String name,
    required Map response,
  }) {
    String classContents =
        "class ${name.toCamelCaseFirstLetterForEachWord()}Model {\n";

    List<Map> mapKeys = [];

    // setup variables
    classContents = SetupHelperMethods.setupVariables(
      data: response,
      content: classContents,
      mapKeys: mapKeys,
    );

    // setup optional constructor
    classContents = SetupHelperMethods.setupOptionalConstructor(
      content: classContents,
      name: name,
      data: response,
    );

    // setup fromJson method
    classContents = SetupHelperMethods.setupFromJson(
      content: classContents,
      name: name,
      data: response,
    );

    // setup toJson method
    classContents = SetupHelperMethods.setupToJson(
      content: classContents,
      data: response,
    );

    // Recursive for each element has value map []
    for (var element in mapKeys) {
      element.forEach((key, value) {
        classContents += _convertMapToClassModel(name: key, response: value);
      });
    }

    return classContents;
  }
}
