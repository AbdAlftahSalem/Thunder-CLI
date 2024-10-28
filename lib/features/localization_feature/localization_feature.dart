import 'package:thunder_cli/features/localization_feature/get_string_to_translate.dart';
import 'package:thunder_cli/features/localization_feature/get_translate_languages.dart';
import 'package:thunder_cli/features/localization_feature/setup_languages_files.dart';
import 'package:thunder_cli/features/localization_feature/translate_languages.dart';

import 'models/from_to_language_model.dart';
import 'models/localization_variables_name.dart';
import 'models/translated_words_model.dart';

class LocalizationFeature {
  static void localizationFeature() async {
    // 1- get the string write in strings_constants.dart
    LocalizationVariablesNameAndWords localizationVariablesNameAndWords =
        await GetStringToTranslate.getStringToTranslate();

    // 2- get from to languages
    FromToLanguageModel fromToLanguageModel =
        GetTranslateLanguages.getTranslateLanguages();

    // 3- setup languages files
    await SetupLanguagesFiles.setupLanguagesFiles(fromToLanguageModel);

    // 4- Translate words to languages
    List<TranslatedWordsModel> translatedWords =
        await TranslateLanguages.translateLanguages(
      localizationVariablesNameAndWords.wordsKeys ?? [],
      fromToLanguageModel,
    );

    // 5- write the translated words in the languages files
    await SetupLanguagesFiles.setupBasicTranslated(
      localizationVariablesNameAndWords,
      translatedWords,
      fromToLanguageModel,
    );
  }
}
