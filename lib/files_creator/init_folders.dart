import 'package:thunder_cli/files_creator/setup_app_folder.dart';
import 'package:thunder_cli/files_creator/setup_packages.dart';
import 'package:thunder_cli/files_creator/setup_theme_folder.dart';
import 'package:thunder_cli/files_creator/setup_util_files.dart';

import '../consts/const.dart';
import '../consts/folder_paths.dart';
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
      FolderPaths.mainFile,
      ConstStrings.instance.main,
    );
  }

  Future<void> _setUpAllFolders() async {
    // create app folder
    CreateFolderAndFiles().createFolder(FolderPaths.appFolder);

    // create utils folder
    CreateFolderAndFiles().createFolder(FolderPaths.utilFolder);

    // create config folder
    CreateFolderAndFiles().createFolder(FolderPaths.configFolder);

    print("Create base folders successfully 🚀🚀");

    await Future.delayed(Duration(milliseconds: 500));
  }
}
