import '../consts/const.dart';
import '../consts/folder_paths.dart';
import '../services/create_folder_files.dart';

class SetUpUtilFolder {
  void setupUtilFolder() {
    // create file in util folder
    CreateFolderAndFiles().createFile(
      FolderPaths.constantsFile,
      ConstStrings.instance.constsApp,
    );

    // init AwesomeNotifications
    CreateFolderAndFiles().createFile(
      FolderPaths.awesomeNotificationsHelperFile,
      ConstStrings.instance.awesomeNotifications,
    );

    // init FcmHelper
    CreateFolderAndFiles().createFile(
      FolderPaths.fcmHelperFile,
      ConstStrings.instance.fcmHelper,
    );

    print("Set all files in app folder successfully 🚀🚀");
  }
}
