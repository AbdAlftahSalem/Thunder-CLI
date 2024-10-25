import 'package:thunder_cli/core/consts/const_strings.dart';
import 'package:thunder_cli/core/consts/folder_paths.dart';
import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';

import '../../core/models/from_to_language_model.dart';
import '../../core/models/localization_variables_name.dart';
import '../../core/models/translated_words_model.dart';

class SetupLanguagesFiles {
  static Future setupLanguagesFiles(
      FromToLanguageModel fromToLanguageModel) async {}

  static Future setupBasicTranslated(
      LocalizationVariablesNameAndWords localizationVariablesNameAndWords,
      List<TranslatedWordsModel> translatedWords,
      FromToLanguageModel fromToLanguageModel) async {
    // setup base language
    await FolderAndFileService.createFile(
      FolderPaths.instance
          .translationFile(fromToLanguageModel.baseLanguage.substring(0, 2)),
      _getTranslatedData(
        fromToLanguageModel.baseLanguage,
        localizationVariablesNameAndWords.variables ?? [],
        localizationVariablesNameAndWords.wordsKeys ?? [],
        true,
      ),
    );

    // setup to languages
    for (var i in translatedWords) {
      await FolderAndFileService.createFile(
        FolderPaths.instance.translationFile(i.language.substring(0, 2)),
        _getTranslatedData(
          i.language,
          localizationVariablesNameAndWords.variables ?? [],
          i.translatedWordsList ?? [],
          false,
        ),
      );
    }

    // set locale.dart
    await FolderAndFileService.createFile(FolderPaths.instance.locale(),
        ConstStrings.instance.myLocale(fromToLanguageModel));
  }

  static String _getTranslatedData(
      String languageName,
      List<String> variablesName,
      List<String> wordsName,
      bool isBasicLanguage) {
    return "import '../constants/strings_constants.dart';\n\nfinal Map<String, String> ${languageName.substring(0, 2)}Language = {\n${_getMapData(variablesName, wordsName)}\n};";
  }

  static String _getMapData(
      List<String> variablesName, List<String> variablesWords) {
    if (variablesName.length != variablesWords.length) {
      print(variablesName);
      print(variablesWords);
      print("😢 Variables name not equal words !!");
      return "";
    }
    String data = "  ";
    for (int index = 0; index < variablesWords.length; index++) {
      data +=
          '${index == 0 ? "" : "  "}StringsConstants.${variablesName[index]} : "${variablesWords[index]}",\n';
    }

    return data;
  }
}
