import 'package:thunder_cli/extensions/string_extensions.dart';

import '../../consts/const_strings.dart';
import '../../consts/folder_paths.dart';
import '../../services/create_folder_files.dart';

class SetupFeatureFiles {
  static void setupFeatureFiles(String className) {
    // // create binding file
    // CreateFolderAndFiles().createFile(
    //   FolderPaths.instancebindingFile(name),
    //   ConstStrings.instance.bindingGetX(name),
    // );

    try {
      // create controller file
      CreateFolderAndFiles().createFile(
        FolderPaths.instance.controllerFile(className),
        ConstStrings.instance
            .controllerGetX(className.toCamelCaseFirstLetter()),
      );

      // create view file
      CreateFolderAndFiles().createFile(
        FolderPaths.instance.viewFile(className),
        ConstStrings.instance.viewGetX(className),
      );
    } catch (e) {
      print('😢 Error in create view or controller . \n $e');
    }
  }
}
