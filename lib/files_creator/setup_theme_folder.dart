import 'package:thunder_cli/consts/folder_paths.dart';

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
    CreateFolderAndFiles().createFolder(FolderPaths.themeFolder);
    CreateFolderAndFiles().createFile(
      FolderPaths.darkThemeColorsFile,
      ConstStrings.instance.darkTheme,
    );

    // create light_theme_colors
    CreateFolderAndFiles().createFile(
      FolderPaths.lightThemeColorsFile,
      ConstStrings.instance.lightTheme,
    );

    // create my_fonts
    CreateFolderAndFiles().createFile(
      FolderPaths.myFontsFile,
      ConstStrings.instance.myFonts,
    );

    // create myStyle
    CreateFolderAndFiles().createFile(
      FolderPaths.myStylesFile,
      ConstStrings.instance.myStyle,
    );

    // create myTheme
    CreateFolderAndFiles().createFile(
      FolderPaths.myThemeFile,
      ConstStrings.instance.myTheme,
    );
  }

  void _setUpTranslations() {
    CreateFolderAndFiles().createFolder(FolderPaths.translationsFolder);

    // create localization_service
    CreateFolderAndFiles().createFile(
      FolderPaths.localizationFile,
      ConstStrings.instance.localizationService,
    );

    // create strings file
    CreateFolderAndFiles().createFile(
      FolderPaths.stringsFile,
      ConstStrings.instance.strings,
    );

    // create en_us_translation
    CreateFolderAndFiles().createFile(
      FolderPaths.enFile,
      ConstStrings.instance.arAr,
    );

    // create ar_ar_translation
    CreateFolderAndFiles().createFile(
      FolderPaths.arFile,
      ConstStrings.instance.enUs,
    );
  }
}
