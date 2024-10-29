import 'dart:convert';
import 'dart:io';

import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';
import 'package:thunder_cli/features/init_project/models/app_data_model.dart';
import 'package:thunder_cli/features/localization_feature/get_string_to_translate.dart';
import 'package:thunder_cli/features/localization_feature/get_translate_languages.dart';
import 'package:thunder_cli/features/localization_feature/translate_languages.dart';

import 'models/from_to_language_model.dart';
import 'models/localization_variables_name.dart';
import 'models/translated_words_model.dart';

class LocalizationFeature {
  static void localizationFeature() async {
    AppDataModel appDataModel = AppDataModel.fromJson(jsonDecode(
        await FolderAndFileService.readFile(
            "${Directory.current.path}\\thunder.json",
            createFileIfNotFound: false)));

    // 1- get the string write in strings_constants.dart
    LocalizationVariablesNameAndWords localizationVariablesNameAndWords =
        await GetStringToTranslate.getStringToTranslate(appDataModel);

    // 2- get from to languages
    FromToLanguageModel fromToLanguageModel =
        await GetTranslateLanguages.getTranslateLanguages(
            appDataModel, localizationVariablesNameAndWords);

    // 3- Translate words to languages
    List<TranslatedWordsModel> translatedWords =
        await TranslateLanguages.translateLanguages(
      localizationVariablesNameAndWords.wordsKeys ?? [],
      fromToLanguageModel,
      lastWordTranslated: appDataModel.localizationModel!.lastWordTranslated,
    );
    // // 4- write the translated words in the languages files
    // await SetupLanguagesFiles.setupBasicTranslated(
    //   appDataModel,
    //   localizationVariablesNameAndWords,
    //   translatedWords,
    //   fromToLanguageModel,
    // );
  }
}
