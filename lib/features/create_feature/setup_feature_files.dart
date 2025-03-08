import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';

import '../../core/consts/const_strings.dart';
import '../../core/consts/folder_paths.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';

class SetupFeatureFiles {
  static Future<void> setupFeatureFiles(String featureName) async {
    try {
      // create controller file
      await FolderAndFileService.createFile(
        FolderPaths.instance.controllerFile(featureName),
        ConstStrings.instance.controllerGetX(featureName),
      );

      // create view file
      await FolderAndFileService.createFile(
        FolderPaths.instance.viewFile(featureName),
        ConstStrings.instance.viewGetX(featureName),
      );

      // create repo file
      await FolderAndFileService.createFile(
        FolderPaths.instance.repoFile(featureName),
        ConstStrings.instance.repo(featureName),
      );

      bindings(featureName);
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

    bindingData = bindingData.map((e) => "  ${(e ?? "").trim()}").toList();

    importData.add(
        "import '../../app/controllers/${className}_controller.dart';");

    importData.add(
        "import '../../app/repositories/${className}_repo.dart';");

    if (bindingData.isEmpty) {
      // main binding in file
      bindingData.add("Get.lazyPut(() => DioHelper());");

      // main Imports in file
      importData.add("import 'package:get/get.dart';");
      importData.add("import '../networking/base_client.dart';");
    }
    bindingData.add(
        "  Get.lazyPut(() => ${className.toCamelCaseFirstLetterForEachWord()}Repo(Get.find<DioHelper>()), fenix: true);");
    bindingData.add(
        "  Get.lazyPut(() => ${className.toCamelCaseFirstLetterForEachWord()}Controller(${className.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}Repo : Get.find<${className.toCamelCaseFirstLetterForEachWord()}Repo>()) , fenix: true);");

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
