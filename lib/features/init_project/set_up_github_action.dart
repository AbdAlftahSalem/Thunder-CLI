import 'dart:io';

import '../../consts/const_strings.dart';
import '../../services/create_folder_files.dart';

class SetUpGithubAction {
  static void setUpGithubAction() {
    print(
        "\n⚡⚡ THUNDER WILL ADD GITHUB ACTION TO SEND APK FILE TO TELEGRAM GROUP AUTOMATICALLY\n** BUT YOU SHOULD MAKE SOME STEPS\n** FOLLOW THIS LINK : \n\n");
    CreateFolderAndFiles().createFolder(Directory.current.path);
    CreateFolderAndFiles().createFolder("${Directory.current.path}\\.github");
    CreateFolderAndFiles()
        .createFolder("${Directory.current.path}\\.github\\workflows");

    CreateFolderAndFiles().createFile(
        "${Directory.current.path}\\.github\\workflows\\build_flutter_apk_and_send_to_telegram.yaml",
        ConstStrings.instance.buildApkFileWorkFlow());

    print("✅ Finished setup GitHub Action successfully 🎉 ...");
  }
}
