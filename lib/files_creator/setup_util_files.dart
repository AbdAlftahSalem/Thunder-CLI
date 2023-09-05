import '../consts/const.dart';
import '../services/create_folder_files.dart';

class SetUpUtilFolder {
  void setupUtilFolder() {
    // create file in util folder
    CreateFolderAndFiles().createFile(
      'utils/constants.dart',
      ConstStrings.instance.constsApp,
    );

    // init AwesomeNotifications
    CreateFolderAndFiles().createFile(
      'utils/awesome_notifications_helper.dart',
      ConstStrings.instance.awesomeNotifications,
    );

    // init FcmHelper
    CreateFolderAndFiles().createFile(
      'utils/fcm_helper.dart',
      ConstStrings.instance.fcmHelper,
    );

    print("Set all files in app folder successfully 🚀🚀");
  }
}
