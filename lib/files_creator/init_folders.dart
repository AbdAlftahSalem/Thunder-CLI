import '../consts/const.dart';
import '../services/create_folder_files.dart';
import '../services/run_cmd.dart';
import './create_module_files.dart';

class InitFolders {
  void initFolders({bool setUpPackage = false}) async {
    // add packages
    if (setUpPackage) {
      await _addPackages();
    }

    // setUp all folders
    await _setUpAllFolders();

    // setUp app files
    _setUpUtilFiles();

    // setUp config files
    _setUpConfigFiles();

    // set up app files
    _setUpAppFiles();

    // set up main file
    CreateFolderAndFiles().createFile(
      'main.dart',
      ConstStrings.instance.main,
    );
  }

  Future<void> _addPackages() async {
    final packages = [
      'get',
      'logger',
      'flutter_screenutil',
      'dio',
      'hive',
      'hive_flutter',
      'shared_preferences',
      'firebase_core',
      'firebase_messaging',
      'awesome_notifications',
      'flutter_launcher_icons',
      'change_app_package_name',
      'rename_app',
      'flutter_svg',
      'pretty_dio_logger',
    ];

    for (final package in packages) {
      await RunCmd.runInCmd('flutter pub add $package');
      print("Add $package package 🚀🚀");
    }
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

  void _setUpAppFiles() async {
    // set up components folder
    await _setUpComponentsFolder();

    // set data folder
    await _setUpDateFolder();

    // setup routes folder
    await _setUpRoutesFolder();

    // set up modules folder
    CreateModuleFiles().createFiles();
  }

  _setUpRoutesFolder() async {
    // create routes folder
    CreateFolderAndFiles()
        .createFolder('app/routes');

    // create app_routes file
    CreateFolderAndFiles().createFile(
      'app/routes/app_routes.dart',
      '',
    );

    // create routes file
    CreateFolderAndFiles().createFile(
      'app/routes/routes.dart',
      '',
    );
  }

  Future<void> _setUpDateFolder() async {
    // create data folder
    CreateFolderAndFiles()
        .createFolder('app/data');
    CreateFolderAndFiles()
        .createFolder('app/data/local');

    // create my_shared_pref file
    CreateFolderAndFiles().createFile(
      'app/data/local/my_shared_pref.dart',
      ConstStrings.instance.sharedPrefs,
    );

    // create hive file
    CreateFolderAndFiles().createFile(
      'app/data/local/hive.dart',
      ConstStrings.instance.hive,
    );

    await Future.delayed(Duration(milliseconds: 500));

    print("Set all files in app/data/locale folder successfully 🚀🚀");

    // create remote folder
    CreateFolderAndFiles()
        .createFolder('app/data/remote');

    // create api_call_status file
    CreateFolderAndFiles().createFile(
      'app/data/remote/api_call_status.dart',
      ConstStrings.instance.apiCallStatus,
    );

    // create api_exceptions file
    CreateFolderAndFiles().createFile(
      'app/data/remote/api_exceptions.dart',
      ConstStrings.instance.apiException,
    );

    // create base_client file
    CreateFolderAndFiles().createFile(
      'app/data/remote/base_client.dart',
      ConstStrings.instance.baseClient,
    );
  }

  Future<void> _setUpComponentsFolder() async {
    // create components folder
    CreateFolderAndFiles().createFolder(
      'app/components',
    );

    // create api_error_widget file
    CreateFolderAndFiles().createFile(
      'app/components/api_error_widget.dart',
      ConstStrings.instance.apiErrorWidget,
    );

    // create custom_snackbar file
    CreateFolderAndFiles().createFile(
      'app/components/custom_snackbar.dart',
      ConstStrings.instance.snackbar,
    );

    // create animated widget
    CreateFolderAndFiles().createFile(
      'app/components/animated_widget.dart',
      ConstStrings.instance.animatedWidget,
    );

    await Future.delayed(Duration(milliseconds: 500));

    print("Set all files in app/components folder successfully 🚀🚀");
  }

  void _setUpUtilFiles() async {
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
    CreateFolderAndFiles()
        .createFolder("config/theme");
    CreateFolderAndFiles().createFile(
      "config/theme/dark_theme_colors.dart",
      ConstStrings.instance.darkTheme,
    );

    // create light_theme_colors
    CreateFolderAndFiles().createFile(
      "config/theme/light_theme_colors.dart",
      ConstStrings.instance.lightTheme,
    );

    // create my_fonts
    CreateFolderAndFiles().createFile(
      "config/theme/my_fonts.dart",
      ConstStrings.instance.myFonts,
    );

    // create myStyle
    CreateFolderAndFiles().createFile(
      "config/theme/my_styles.dart",
      ConstStrings.instance.myStyle,
    );

    // create myTheme
    CreateFolderAndFiles().createFile(
      "config/theme/my_theme.dart",
      ConstStrings.instance.myTheme,
    );
  }

  void _setUpTranslations() {
    CreateFolderAndFiles()
        .createFolder("config/translations");

    // create localization_service
    CreateFolderAndFiles().createFile(
      "config/translations/localization_service.dart",
      ConstStrings.instance.localizationService,
    );

    // create strings file
    CreateFolderAndFiles().createFile(
      "config/translations/strings.dart",
      ConstStrings.instance.strings,
    );

    // create en_us_translation
    CreateFolderAndFiles().createFile(
      "config/translations/ar_Ar_translation.dart",
      ConstStrings.instance.arAr,
    );

    // create ar_ar_translation
    CreateFolderAndFiles().createFile(
      "config/translations/ar_En_translation.dart",
      ConstStrings.instance.enUs,
    );
  }
}
