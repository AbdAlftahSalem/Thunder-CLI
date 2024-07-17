import 'package:thunder_cli/core/helper/extensions/string_extensions.dart';

import '../../core/helper/consts/const_strings.dart';
import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/create_file.dart';

class SetupFeatureFiles {
  static void setupFeatureFiles(String className) {
    // // create binding file
    // CreateFolderAndFiles().createFile(
    //   FolderPaths.instancebindingFile(name),
    //   ConstStrings.instance.bindingGetX(name),
    // );

    try {
      // create controller file
      CreateFile.createFile(
        FolderPaths.instance.controllerFile(className),
        ConstStrings.instance
            .controllerGetX(className.toCamelCaseFirstLetter()),
      );

      // create view file
      CreateFile.createFile(
        FolderPaths.instance.viewFile(className),
        ConstStrings.instance.viewGetX(className),
      );
    } catch (e) {
      print('😢 Error in create view or controller . \n $e');
    }
  }
}
