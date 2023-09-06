import 'package:thunder_cli/files_creator/setup_app_folder.dart';
import 'package:thunder_cli/files_creator/setup_packages.dart';
import 'package:thunder_cli/files_creator/setup_theme_folder.dart';
import 'package:thunder_cli/files_creator/setup_util_files.dart';

import '../consts/const.dart';
import '../services/create_folder_files.dart';

class InitFolders {
  void initFolders({bool setUpPackage = false}) async {
    // add packages
    if (setUpPackage) {
      await SetupPackages().setupPackages();
    }

    // setUp all folders
    await _setUpAllFolders();

    SetupAppFolder().setupAppFolder();

    SetUpUtilFolder().setupUtilFolder();

    // setUp config files
    SetupConfigFolder().setUpConfigFiles();

    // set up main file
    CreateFolderAndFiles().createFile(
      'main.dart',
      ConstStrings.instance.main,
    );
  }

  Future<void> _setUpAllFolders() async {
    // create app folder
    CreateFolderAndFiles().createFolder('app');

    // create utils folder
    CreateFolderAndFiles().createFolder('utils');

    // create config folder
    CreateFolderAndFiles().createFolder('config');

    print("Create base folders successfully 🚀🚀");

    await Future.delayed(Duration(milliseconds: 500));
  }
}
