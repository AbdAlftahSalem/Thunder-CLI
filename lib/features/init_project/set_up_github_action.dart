import 'dart:io';

import '../../core/helper/consts/const_strings.dart';
import '../../core/helper/services/folder_and_file_service/create_file.dart';
import '../../core/helper/services/folder_and_file_service/create_folder.dart';

class SetUpGithubAction {
  static void setUpGithubAction() {
    print(
        "\n⚡⚡ THUNDER WILL ADD GITHUB ACTION TO SEND APK FILE TO TELEGRAM GROUP AUTOMATICALLY\n** BUT YOU SHOULD MAKE SOME STEPS\n** FOLLOW THIS LINK : \n\n");
    CreateFolder.createFolder(Directory.current.path);
    CreateFolder.createFolder("${Directory.current.path}\\.github");
    CreateFolder.createFolder("${Directory.current.path}\\.github\\workflows");

    CreateFile.createFile(
        "${Directory.current.path}\\.github\\workflows\\build_flutter_apk_and_send_to_telegram.yaml",
        ConstStrings.instance.buildApkFileWorkFlow());

    print("✅ Finished setup GitHub Action successfully 🎉 ...");
  }
}
