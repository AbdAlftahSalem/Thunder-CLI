import 'dart:io';

import 'package:thunder_cli/core/helper/extensions/string_extensions.dart';

import '../../core/helper/consts/const_strings.dart';
import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/create_file.dart';

class SetupFeatureFiles {
  static void setupFeatureFiles(String className) {
    try {
      // create controller file
      CreateFile.createFile(
        FolderPaths.instance.controllerFile(className),
        ConstStrings.instance
            .controllerGetX(className.toCamelCaseFirstLetterForEachWord()),
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

  static void bindings(String className) {
    // reading bindings.dart file
    final file = File(FolderPaths.instance.bindingsFile);

    String contentFile = file.readAsStringSync();

    final importData = RegExp(r'import.*?;')
        .allMatches(contentFile)
        .map((e) => e.group(0))
        .toList();

    final bindingData = RegExp(r'Get.*?;')
        .allMatches(contentFile)
        .map((e) => e.group(0))
        .toList();

    importData
        .add("import '/app/features/$className/${className}_controller.dart';");

    bindingData.add(
        "Get.lazyPut<${className.toCamelCaseFirstLetterForEachWord()}Controller>(() => ${className.toCamelCaseFirstLetterForEachWord()}Controller());");

    String newBindingFile = """
${importData.join("\n")}

class BindingApp extends Bindings {
  @override
  void dependencies() {
    ${bindingData.join("\n")}
   }
}
  """;

    file.writeAsStringSync(newBindingFile);
  }
}
