import 'dart:io';

import '../../core/helper/consts/const_strings.dart';
import '../../core/helper/services/folder_and_file_service/folder_and_file_service.dart';

class SetUpGithubAction {
  static Future<void> setUpGithubAction() async {
    print(
        "\n⚡⚡ THUNDER WILL ADD GITHUB ACTION TO SEND APK FILE TO TELEGRAM GROUP AUTOMATICALLY\n** BUT YOU SHOULD MAKE SOME STEPS\n** FOLLOW THIS LINK : \n\n");
    FolderAndFileService.createFolder(Directory.current.path);
    FolderAndFileService.createFolder("${Directory.current.path}\\.github");
    FolderAndFileService.createFolder(
        "${Directory.current.path}\\.github\\workflows");

    await FolderAndFileService.createFile(
        "${Directory.current.path}\\.github\\workflows\\build_flutter_apk_and_send_to_telegram.yaml",
        ConstStrings.instance.buildApkFileWorkFlow());

    print("✅ Finished setup GitHub Action successfully 🎉 ...");
  }
}
