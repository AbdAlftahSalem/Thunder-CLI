import 'dart:io';

import 'package:thunder_cli/core/helper/extensions/string_extensions.dart';

import '../../core/helper/consts/const_strings.dart';
import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/folder_and_file_service.dart';

class SetupFeatureFiles {
  static void setupFeatureFiles(String className) {
    try {
      // create controller file
      FolderAndFileService.createFile(
        FolderPaths.instance.controllerFile(className),
        ConstStrings.instance
            .controllerGetX(className.toCamelCaseFirstLetterForEachWord()),
      );

      // create view file
      FolderAndFileService.createFile(
        FolderPaths.instance.viewFile(className),
        ConstStrings.instance.viewGetX(className),
      );
    } catch (e) {
      print('😢 Error in create view or controller . \n $e');
    }
  }

  static void bindings(String className) async {
    // reading bindings.dart file
    String contentFile = await FolderAndFileService.readFile(FolderPaths.instance.bindingsFile);

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

    final file = File(FolderPaths.instance.bindingsFile);
    file.writeAsStringSync(newBindingFile);
  }
}
