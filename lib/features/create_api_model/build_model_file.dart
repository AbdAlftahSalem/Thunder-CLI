import 'package:thunder_cli/extensions/string_extensions.dart';
import 'package:thunder_cli/features/create_api_model/setup_helper_methods.dart';

import '../../consts/folder_paths.dart';
import '../../services/create_folder_files.dart';

class BuildModelFile {
  static void buildModelFile({
    required String modelName,
    required dynamic data,
  }) {
    // create model file
    CreateFolderAndFiles().createFile(
      FolderPaths.instance.modelFile(modelName),
      _convertMapToClassModel(
        name: modelName,
        data: data is Map ? data : data[0],
      ),
    );

    print("⚡ Create model file successfully\n\n");
  }

  static String _convertMapToClassModel({
    required String name,
    required Map data,
  }) {
    String classContents = "class ${name.toCamelCaseFirstLetter()}Model {\n";

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
