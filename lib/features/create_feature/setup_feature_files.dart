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
            .controllerGetX(className),
      );

      // create view file
      FolderAndFileService.createFile(
        FolderPaths.instance.viewFile(className),
        ConstStrings.instance.viewGetX(className),
      );

      // create repo file
      FolderAndFileService.createFile(
        FolderPaths.instance.repoFile(className),
        ConstStrings.instance.repo(className),
      );

      bindings(className);
    } catch (e) {
      print('😢 Error in create view or controller . \n $e');
    }
  }

  static void bindings(String className) async {
    // reading bindings.dart file
    String contentFile =
        await FolderAndFileService.readFile(FolderPaths.instance.bindingsFile);

    List<String?> importData = RegExp(r'import.*?;')
        .allMatches(contentFile)
        .map((e) => e.group(0))
        .toList();

    List<String?> bindingData = RegExp(r'Get.*?;')
        .allMatches(contentFile)
        .map((e) => e.group(0))
        .toList();

    importData
        .add("import '/app/features/$className/${className}_controller.dart';");

    if (bindingData.isEmpty) {
      bindingData.add("Get.lazyPut(() => DioHelper());");
      bindingData.add("Get.lazyPut(() => HomeRepo(Get.find<DioHelper>()));");
    }

    bindingData.add(
        "Get.lazyPut(() => ${className.toCamelCaseFirstLetterForEachWord()}Controller(${className.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}Repo : Get.find<${className.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}Repo>()));");

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
