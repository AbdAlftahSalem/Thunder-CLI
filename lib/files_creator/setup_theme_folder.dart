import '../consts/const.dart';
import '../services/create_folder_files.dart';

class SetupConfigFolder {
  void setUpConfigFiles() {
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
