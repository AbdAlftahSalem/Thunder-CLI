import 'package:thunder_cli/core/helper/extensions/string_extensions.dart';
import 'package:thunder_cli/core/models/request_model.dart';
import 'package:thunder_cli/features/create_api_model/setup_helper_methods.dart';

import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/folder_and_file_service.dart';

class BuildModelFile {
  static void buildModelFile({
    required RequestModel requestModel,
    required dynamic data,
  }) {
    // create model file
    FolderAndFileService.createFile(
      FolderPaths.instance.modelFile(requestModel.modelName, requestModel.featureName),
      _convertMapToClassModel(
        name: requestModel.modelName,
        data: data is Map ? data : data[0],
      ),
    );

    print("⚡ Create model file successfully\n\n");
  }

  static String _convertMapToClassModel({
    required String name,
    required Map data,
  }) {
    String classContents = "class ${name.toCamelCaseFirstLetterForEachWord()}Model {\n";

    List<Map> mapKeys = [];

    // setup variables
    classContents = SetupHelperMethods.setupVariables(
      data: data,
      content: classContents,
      mapKeys: mapKeys,
    );

    // setup optional constructor
    classContents = SetupHelperMethods.setupOptionalConstructor(
      content: classContents,
      name: name,
      data: data,
    );

    // setup fromJson method
    classContents = SetupHelperMethods.setupFromJson(
      content: classContents,
      name: name,
      data: data,
    );

    // setup toJson method
    classContents = SetupHelperMethods.setupToJson(
      content: classContents,
      data: data,
    );

    // ❌ ❌ TODO : This maybe not working ❌ ❌
    // Recursive for each element has value map []
    for (var element in mapKeys) {
      element.forEach((key, value) {
        classContents += _convertMapToClassModel(name: key, data: value);
      });
    }

    return classContents;
  }
}
