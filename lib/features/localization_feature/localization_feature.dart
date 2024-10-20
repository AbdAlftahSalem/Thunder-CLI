import 'package:thunder_cli/features/localization_feature/get_string_to_translate.dart';
import 'package:thunder_cli/features/localization_feature/get_translate_languages.dart';
import 'package:thunder_cli/features/localization_feature/setup_languages_files.dart';

import '../../core/models/from_to_language_model.dart';

class LocalizationFeature {
  static void localizationFeature() async {
    // 1- get the string write in strings_constants.dart
    List<String> wordsToTranslate =
        await GetStringToTranslate.getStringToTranslate();

    // 2- get from to languages
    FromToLanguageModel fromToLanguageModel =
        GetTranslateLanguages.getTranslateLanguages();

    // 3- setup languages files
    await SetupLanguagesFiles.setupLanguagesFiles(fromToLanguageModel);
  }
}
