import 'dart:io';

import 'package:thunder_cli/files_creator/setup_app_folder.dart';
import 'package:thunder_cli/files_creator/setup_packages.dart';
import 'package:thunder_cli/files_creator/setup_theme_folder.dart';
import 'package:thunder_cli/files_creator/setup_util_files.dart';

import '../consts/const.dart';
import '../consts/folder_paths.dart';
import '../services/create_folder_files.dart';

class InitFolders {
  void initFolders({bool setUpPackage = false}) async {
    Map<String, String> appInfo = await _userApplicationData();

    print("Thunder will init your app . please wait for seconds 🔃");

    // add packages
    if (setUpPackage) {
      await SetupPackagesAndAppInfo().setupPackagesAndAppInfo(appInfo);
    }

    SetupAppFolder().setupAppFolder();

    SetUpUtilFolder().setupUtilFolder();

    // setUp config files
    SetupConfigFolder().setUpConfigFiles();

    // set up main file
    CreateFolderAndFiles().createFile(
      FolderPaths.mainFile,
      ConstStrings.instance.main,
    );

    print("⚡ ⚡ Init app successfully");
  }

  Future<Map<String, String>> _userApplicationData() async {
    stdout.write('😎 Enter your application name: ');
    String appName = stdin.readLineSync() ?? "";

    if (appName.isEmpty) {
      print('😢 Application name cannot be empty');
      return {};
    }

    stdout.write('😎 Enter your package name : ');
    String packageName = stdin.readLineSync() ?? "";

    if (packageName.isEmpty) {
      print('😢 Package name cannot be empty');
      return {};
    }

    appName = appName.trim().replaceAll(" ", "_").toLowerCase();

    return {
      'appName': appName,
      'packageName': packageName,
    };
  }
}
