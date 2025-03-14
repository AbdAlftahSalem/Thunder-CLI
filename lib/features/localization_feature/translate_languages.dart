import 'package:thunder_cli/features/localization_feature/models/from_to_language_model.dart';
import 'package:thunder_cli/features/localization_feature/models/translated_words_model.dart';
import 'package:translator/translator.dart';

class TranslateLanguages {
  static Future translateLanguages(
      List<String> wordsToTranslate, FromToLanguageModel fromToLanguageModel,
      {String lastWordTranslated = ""}) async {
    // set up multiple lists

    if (lastWordTranslated.isNotEmpty) {
      int endIndex = wordsToTranslate
              .indexWhere((element) => element == lastWordTranslated) +
          1;
      wordsToTranslate.removeRange(0, endIndex);
    }

    List<String> wordsAdapter = _setupWordsToTranslate(wordsToTranslate);
    List<TranslatedWordsModel> translatedWords = [];
    TranslatedWordsModel translatedWordsModel = TranslatedWordsModel(
      baseWordsString: wordsAdapter.join(" || "),
      baseWordsList: wordsAdapter,
      fromLanguage: fromToLanguageModel.baseLanguage,
    );

    // translate words ...
    for (String words in wordsAdapter) {
      for (ToLanguages toLanguage in fromToLanguageModel.toLanguages) {
        String translatedWord = await _translate(
          baseLanguage: fromToLanguageModel.baseLanguage,
          toLanguage: toLanguage.languageName,
          content: words,
        );

        translatedWordsModel.translatedWordsString = "$translatedWord || ";
        translatedWordsModel.toLanguage = toLanguage.languageName;
        translatedWordsModel.translatedWordsList = translatedWordsModel
            .translatedWordsString
            .split("||")
            .map((e) => e.trim())
            .toList();
        translatedWordsModel.translatedWordsList
            ?.removeWhere((element) => element.isEmpty);

        translatedWords.add(translatedWordsModel);
        translatedWordsModel.language = toLanguage.languageName;
        if (translatedWord.trim().replaceAll("||", "").isNotEmpty) {
          print(
              "✅ Translated ${translatedWordsModel.translatedWordsList!.length} words to ${toLanguage.languageName} successfully ...");
        }
      }
    }
    return translatedWords;
  }

  static List<String> _setupWordsToTranslate(List<String> words) {
    List<String> outputWords = [];
    String wordsStringToTranslate = "";

    for (String i in words) {
      wordsStringToTranslate += "$i || ";
      if (wordsStringToTranslate.length >= 1500) {
        outputWords.add(wordsStringToTranslate);
        wordsStringToTranslate = "";
      }
    }
    if (wordsStringToTranslate.isNotEmpty) {
      outputWords.add(wordsStringToTranslate);
      wordsStringToTranslate = "";
    }

    return outputWords;
  }

  static Future<String> _translate({
    required String baseLanguage,
    required String toLanguage,
    required String content,
  }) async {
    // translate code ...
    try {
      Translation translatedWord = await GoogleTranslator().translate(
        content,
        from: baseLanguage,
        to: toLanguage,
      );
      return translatedWord.toString();
    } catch (e) {
      print("😢 Error in translation : $e");
    }

    return "";
  }
}
