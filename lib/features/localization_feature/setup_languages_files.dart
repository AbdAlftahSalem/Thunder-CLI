import 'package:thunder_cli/core/extensions/app_data_extesions.dart';
import 'package:thunder_cli/features/init_project/models/app_data_model.dart';

import '../../core/consts/const_strings.dart';
import '../../core/consts/folder_paths.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';
import 'models/from_to_language_model.dart';
import 'models/localization_variables_name.dart';
import 'models/translated_words_model.dart';

class SetupLanguagesFiles {
  static Future setupBasicTranslated(
      AppDataModel appDataModel,
      LocalizationVariablesNameAndWords localizationVariablesNameAndWords,
      List<TranslatedWordsModel> translatedWords,
      FromToLanguageModel fromToLanguageModel) async {
    if (appDataModel.localizationModel!.baseLanguage.isNotEmpty) {}

    // setup base language
    await FolderAndFileService.createFile(
      FolderPaths.instance
          .translationFile(fromToLanguageModel.baseLanguage.substring(0, 2)),
      await _getTranslatedData(
          fromToLanguageModel.baseLanguage,
          localizationVariablesNameAndWords.variables ?? [],
          localizationVariablesNameAndWords.wordsKeys ?? [],
          false),
    );
    //
    // setup to languages
    for (var i in translatedWords) {
      await FolderAndFileService.createFile(
        FolderPaths.instance.translationFile(i.language.substring(0, 2)),
        await _getTranslatedData(
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

    appDataModel.localizationModel!.lastWordTranslated =
        (localizationVariablesNameAndWords.wordsKeys ?? [""]).last;
    // await appDataModel.saveModel();
  }

  static Future<String> _getTranslatedData(
      String languageName,
      List<String> variablesName,
      List<String> wordsName,
      bool isFirstTime) async {
    if (isFirstTime) {
      return "import '../constants/strings_constants.dart';\n\nfinal Map<String, String> ${languageName.substring(0, 2)}Language = {\n${_getMapData(variablesName, wordsName)}\n};";
    }

    // read previous file data
    String content = await FolderAndFileService.readFile(
        FolderPaths.instance.translationFile(languageName));

    if (content.isEmpty) {
      return "import '../constants/strings_constants.dart';\n\nfinal Map<String, String> ${languageName.substring(0, 2)}Language = {\n${_getMapData(variablesName, wordsName)}\n};";
    }

    return content.replaceAll(
        "};", "${_getMapData(variablesName, wordsName)}\n};");
  }

  static String _getMapData(
      List<String> variablesName, List<String> variablesWords) {
    if (variablesName.length != variablesWords.length) {
      variablesName =
          variablesName.sublist(variablesName.length - variablesWords.length);
    }
    String data = "  ";
    for (int index = 0; index < variablesWords.length; index++) {
      data +=
          '${index == 0 ? "" : "  "}StringsConstants.${variablesName[index]} : "${variablesWords[index]}",\n';
    }

    return data;
  }
}
