class FolderPaths {
  static const String appFolder = 'lib/app';
  static const String configFolder = 'lib/config';
  static const String utilFolder = 'lib/utils';

  //  *******  app files and folders  *******

  static const String componentsFolder = 'lib/app/components';
  static const String dataFolder = 'lib/app/data';
  static const String modulesFolder = 'lib/app/modules';
  static const String routesFolder = 'lib/app/routes';

  // components files
  static const String animatedWidgetFile =
      'lib/app/components/animated_widget.dart';
  static const String apiErrorWidgetFile =
      'lib/app/components/api_error_widget.dart';
  static const String snackbarWidgetFile =
      'lib/app/components/custom_snackbar.dart';

  // data files
  static const String localFolder = 'lib/app/data/local';
  static const String remoteFolder = 'lib/app/data/remote';
  static const String modelsFolder = 'lib/app/data/models';

  // local files
  static const String hiveFile = 'lib/app/data/local/hive.dart';
  static const String sharedPrefFile = 'lib/app/data/local/my_shared_pref.dart';

  // remote files
  static const String baseClientFile = 'lib/app/data/remote/base_client.dart';
  static const String apiCallStateFile =
      'lib/app/data/remote/api_call_state.dart';
  static const String apiExceptionFile =
      'lib/app/data/remote/api_exception.dart';

  // models files
  static String modelFile(String name) =>
      'lib/app/data/models/${name.toLowerCase()}_model.dart';

  // routes files
  static const String appRoutesFile = 'lib/app/routes/app_routes.dart';
  static const String routesFile = 'lib/app/routes/routes.dart';

  // module files
  static String folderInModules(String name) =>
      'lib/app/modules/$name';

  static String controllerFolder(String name) =>
      "lib/app/modules/$name/controller";

  static String viewFolder(String name) => "lib/app/modules/$name/view";

  static String bindingFolder(String name) => "lib/app/modules/$name/binding";

  static String bindingFile(String name) =>
      'lib/app/modules/$name/binding/${name.toLowerCase()}_binding.dart';

  static String controllerFile(String name) =>
      'lib/app/modules/$name/controller/${name.toLowerCase()}_controller.dart';

  static String viewFile(String name) =>
      'lib/app/modules/$name/view/${name.toLowerCase()}_view.dart';

  // *******  config files and folders  *******
  static const String themeFolder = 'lib/config/theme';
  static const String translationsFolder = 'lib/config/translations';

  // theme files
  static const String darkThemeColorsFile =
      'lib/config/theme/dark_theme_colors.dart';
  static const String lightThemeColorsFile =
      'lib/config/theme/light_theme_colors.dart';
  static const myThemeFile = 'lib/config/theme/my_theme.dart';
  static const myStylesFile = 'lib/config/theme/my_styles.dart';
  static const myFontsFile = 'lib/config/theme/my_fonts.dart';

  // translations files
  static const String enFile =
      'lib/config/translations/ar_En_translations.dart';
  static const String arFile =
      'lib/config/translations/ar_Ar_translations.dart';
  static const String localizationFile =
      'lib/config/translations/localization_service.dart';
  static const String stringsFile = 'lib/config/translations/strings.dart';

  // *******  utils files and folders  *******
  static const String constantsFile = 'lib/utils/constants.dart';
  static const String fcmHelperFile = 'lib/utils/fcm_helper.dart';
  static const String awesomeNotificationsHelperFile =
      'lib/utils/awesome_notifications_helper.dart';

  // *******  main file  *******
  static const String mainFile = 'lib/main.dart';
}
