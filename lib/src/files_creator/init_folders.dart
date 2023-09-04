import '../consts/const.dart';
import '../services/create_folder_files.dart';

class InitFolders {
  void initFolders() async {
    // setUp all folders
    await _setUpAllFolders();

    // setUp app files
    _setUpUtilFiles();

    // setUp config files
    _setUpConfigFiles();

    // set up app files
    _setUpAppFiles();
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

    // set up modules folder
    await _setUpModulesFolder();
  }

  Future<void> _setUpDateFolder() async {
    // create data folder
    CreateFolderAndFiles().createFolder('app/data');
    CreateFolderAndFiles().createFolder('app/data/local');

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
    CreateFolderAndFiles().createFolder('app/data/remote');

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

  Future<void> _setUpModulesFolder() async {
    // create modules folder
    CreateFolderAndFiles().createFolder('app/modules');
    // create binding folder
    CreateFolderAndFiles().createFolder('app/modules/binding');

    // create home binding file
    CreateFolderAndFiles().createFile(
      'app/modules/binding/home_binding.dart',
      ConstStrings.instance.binding("HomeBinding"),
    );

    // controller folder
    CreateFolderAndFiles().createFolder('app/modules/controller');

    // create home controller file
    CreateFolderAndFiles().createFile(
      'app/modules/controller/home_controller.dart',
      ConstStrings.instance.controller("HomeController"),
    );

    // create view folder
    CreateFolderAndFiles().createFolder('app/modules/view');

    // create home view file
    CreateFolderAndFiles().createFile(
      'app/modules/view/home_view.dart',
      ConstStrings.instance.view("HomeScreen"),
    );
  }

  Future<void> _setUpComponentsFolder() async {
    // create components folder
    CreateFolderAndFiles().createFolder('app/components');

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
    CreateFolderAndFiles().createFolder("config/theme");
    CreateFolderAndFiles().createFile(
      "config/theme/dark_theme_colors.dart",
      ConstStrings.instance.darkTheme,
    );

    // create light_theme_colors
    CreateFolderAndFiles().createFile(
      "config/theme/light_theme_colors.dart",
      ConstStrings.instance.lightTheme,
    );
  }

  void _setUpTranslations() {
    CreateFolderAndFiles().createFolder("config/translations");

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
      "config/translations/ar_ar_translation.dart",
      ConstStrings.instance.arAr,
    );

    // create ar_ar_translation
    CreateFolderAndFiles().createFile(
      "config/translations/ar_ar_translation.dart",
      ConstStrings.instance.enUs,
    );
  }
}
