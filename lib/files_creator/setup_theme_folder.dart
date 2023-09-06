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
    CreateFolderAndFiles().createFolder("lib/config/theme");
    CreateFolderAndFiles().createFile(
      "lib/config/theme/dark_theme_colors.dart",
      ConstStrings.instance.darkTheme,
    );

    // create light_theme_colors
    CreateFolderAndFiles().createFile(
      "lib/config/theme/light_theme_colors.dart",
      ConstStrings.instance.lightTheme,
    );

    // create my_fonts
    CreateFolderAndFiles().createFile(
      "lib/config/theme/my_fonts.dart",
      ConstStrings.instance.myFonts,
    );

    // create myStyle
    CreateFolderAndFiles().createFile(
      "lib/config/theme/my_styles.dart",
      ConstStrings.instance.myStyle,
    );

    // create myTheme
    CreateFolderAndFiles().createFile(
      "lib/config/theme/my_theme.dart",
      ConstStrings.instance.myTheme,
    );
  }

  void _setUpTranslations() {
    CreateFolderAndFiles().createFolder("lib/config/translations");

    // create localization_service
    CreateFolderAndFiles().createFile(
      "lib/config/translations/localization_service.dart",
      ConstStrings.instance.localizationService,
    );

    // create strings file
    CreateFolderAndFiles().createFile(
      "lib/config/translations/strings.dart",
      ConstStrings.instance.strings,
    );

    // create en_us_translation
    CreateFolderAndFiles().createFile(
      "lib/config/translations/ar_Ar_translation.dart",
      ConstStrings.instance.arAr,
    );

    // create ar_ar_translation
    CreateFolderAndFiles().createFile(
      "lib/config/translations/ar_En_translation.dart",
      ConstStrings.instance.enUs,
    );
  }
}
