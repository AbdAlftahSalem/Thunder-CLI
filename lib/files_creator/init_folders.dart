import '../consts/const.dart';
import '../services/create_folder_files.dart';
import '../services/run_cmd.dart';

class InitFolders {
  void initFolders() async {
    // // add packages
    // await _addPackages();

    // setUp all folders
    await _setUpAllFolders();

    // setUp app files
    // _setUpUtilFiles();

    // setUp config files
    // _setUpConfigFiles();

    // set up app files
    _setUpAppFiles();

    // set up main file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/main.dart',
      ConstStrings.instance.main,
    );
  }

  Future<void> _addPackages() async {
    // add get package
    await RunCmd.runInCmd('flutter pub add get');
    print("Add get package 🚀🚀");

    // add logger
    await RunCmd.runInCmd('flutter pub add logger');
    print("Add logger package 🚀🚀");

    // add flutter_screenutil
    await RunCmd.runInCmd('flutter pub add flutter_screenutil');
    print("Add flutter_screenutil package 🚀🚀");

    // add dio
    await RunCmd.runInCmd('flutter pub add dio');
    print("Add dio package 🚀🚀");

    // add hive
    await RunCmd.runInCmd('flutter pub add hive');
    print("Add hive package 🚀🚀");

    // add hive_flutter
    await RunCmd.runInCmd('flutter pub add hive_flutter');
    print("Add hive_flutter package 🚀🚀");

    // add shared_preferences
    await RunCmd.runInCmd('flutter pub add shared_preferences');
    print("Add shared_preferences package 🚀🚀");

    // add firebase_core
    await RunCmd.runInCmd('flutter pub add firebase_core');
    print("Add firebase_core package 🚀🚀");

    // add firebase_messaging
    await RunCmd.runInCmd('flutter pub add firebase_messaging');
    print("Add firebase_messaging package 🚀🚀");

    // add awesome_notifications
    await RunCmd.runInCmd('flutter pub add awesome_notifications');
    print("Add awesome_notifications package 🚀🚀");

    // add flutter_launcher_icons
    await RunCmd.runInCmd('flutter pub add flutter_launcher_icons');
    print("Add flutter_launcher_icons package 🚀🚀");

    // add change_app_package_name
    await RunCmd.runInCmd('flutter pub add change_app_package_name');
    print("Add change_app_package_name package 🚀🚀");

    // add rename_app
    await RunCmd.runInCmd('flutter pub add rename_app');
    print("Add rename_app package 🚀🚀");

    // add flutter_svg
    await RunCmd.runInCmd('flutter pub add flutter_svg');
    print("Add flutter_svg package 🚀🚀");
  }

  Future<void> _setUpAllFolders() async {
    // create app folder
    CreateFolderAndFiles().createFolder('E:/Flutter new/crypto_new/lib/app');

    // create utils folder
    CreateFolderAndFiles().createFolder('E:/Flutter new/crypto_new/lib/utils');

    // create config folder
    CreateFolderAndFiles().createFolder('E:/Flutter new/crypto_new/lib/config');

    print("Create base folders successfully 🚀🚀");

    await Future.delayed(Duration(milliseconds: 500));
  }

  void _setUpAppFiles() async {
    // set up components folder
    await _setUpComponentsFolder();

    // set data folder
    await _setUpDateFolder();

    // set up modules folder
    await _setUpModulesFolder();
  }

  Future<void> _setUpDateFolder() async {
    // create data folder
    CreateFolderAndFiles()
        .createFolder('E:/Flutter new/crypto_new/lib/app/data');
    CreateFolderAndFiles()
        .createFolder('E:/Flutter new/crypto_new/lib/app/data/local');

    // create my_shared_pref file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/data/local/my_shared_pref.dart',
      ConstStrings.instance.sharedPrefs,
    );

    // create hive file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/data/local/hive.dart',
      ConstStrings.instance.hive,
    );

    await Future.delayed(Duration(milliseconds: 500));

    print("Set all files in app/data/locale folder successfully 🚀🚀");

    // create remote folder
    CreateFolderAndFiles()
        .createFolder('E:/Flutter new/crypto_new/lib/app/data/remote');

    // create api_call_status file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/data/remote/api_call_status.dart',
      ConstStrings.instance.apiCallStatus,
    );

    // create api_exceptions file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/data/remote/api_exceptions.dart',
      ConstStrings.instance.apiException,
    );

    // create base_client file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/data/remote/base_client.dart',
      ConstStrings.instance.baseClient,
    );
  }

  Future<void> _setUpModulesFolder() async {
    // create modules folder
    CreateFolderAndFiles()
        .createFolder('E:/Flutter new/crypto_new/lib/app/modules');
    // create binding folder
    CreateFolderAndFiles()
        .createFolder('E:/Flutter new/crypto_new/lib/app/modules/binding');

    // create home binding file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/modules/binding/home_binding.dart',
      ConstStrings.instance.binding("HomeBinding"),
    );

    // controller folder
    CreateFolderAndFiles()
        .createFolder('E:/Flutter new/crypto_new/lib/app/modules/controller');

    // create home controller file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/modules/controller/home_controller.dart',
      ConstStrings.instance.controller("HomeController"),
    );

    // create view folder
    CreateFolderAndFiles()
        .createFolder('E:/Flutter new/crypto_new/lib/app/modules/view');

    // create home view file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/modules/view/home_view.dart',
      ConstStrings.instance.view("HomeScreen"),
    );
  }

  Future<void> _setUpComponentsFolder() async {
    // create components folder
    CreateFolderAndFiles().createFolder(
      'E:/Flutter new/crypto_new/lib/app/components',
    );

    // create api_error_widget file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/components/api_error_widget.dart',
      ConstStrings.instance.apiErrorWidget,
    );

    // create custom_snackbar file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/components/custom_snackbar.dart',
      ConstStrings.instance.snackbar,
    );

    // create animated widget
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/components/animated_widget.dart',
      ConstStrings.instance.animatedWidget,
    );

    await Future.delayed(Duration(milliseconds: 500));

    print("Set all files in app/components folder successfully 🚀🚀");
  }

  void _setUpUtilFiles() async {
    // create file in util folder
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/utils/constants.dart',
      ConstStrings.instance.constsApp,
    );

    // init AwesomeNotifications
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/utils/awesome_notifications_helper.dart',
      ConstStrings.instance.awesomeNotifications,
    );

    // init FcmHelper
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/utils/fcm_helper.dart',
      ConstStrings.instance.fcmHelper,
    );

    print("Set all files in app folder successfully 🚀🚀");

    await Future.delayed(Duration(milliseconds: 500));
  }

  void _setUpConfigFiles() {
    // create translations folder
    _setUpTranslations();

    // set up theme folder
    _setUpTheme();

    print("Set all files in config folder successfully 🚀🚀");
  }

  void _setUpTheme() {
    // create dark_theme_colors
    CreateFolderAndFiles().createFolder("E:/Flutter new/crypto_new/config/theme");
    CreateFolderAndFiles().createFile(
      "E:/Flutter new/crypto_new/lib/config/theme/dark_theme_colors.dart",
      ConstStrings.instance.darkTheme,
    );

    // create light_theme_colors
    CreateFolderAndFiles().createFile(
      "E:/Flutter new/crypto_new/lib/config/theme/light_theme_colors.dart",
      ConstStrings.instance.lightTheme,
    );
  }

  void _setUpTranslations() {
    CreateFolderAndFiles().createFolder("E:/Flutter new/crypto_new/lib/config/translations");

    // create localization_service
    CreateFolderAndFiles().createFile(
      "E:/Flutter new/crypto_new/lib/config/translations/localization_service.dart",
      ConstStrings.instance.localizationService,
    );

    // create strings file
    CreateFolderAndFiles().createFile(
      "E:/Flutter new/crypto_new/lib/config/translations/strings.dart",
      ConstStrings.instance.strings,
    );

    // create en_us_translation
    CreateFolderAndFiles().createFile(
      "E:/Flutter new/crypto_new/lib/config/translations/ar_ar_translation.dart",
      ConstStrings.instance.arAr,
    );

    // create ar_ar_translation
    CreateFolderAndFiles().createFile(
      "E:/Flutter new/crypto_new/lib/config/translations/ar_ar_translation.dart",
      ConstStrings.instance.enUs,
    );
  }
}
