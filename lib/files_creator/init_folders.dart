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
}
