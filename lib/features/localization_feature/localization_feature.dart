import 'get_string_to_ranslate.dart';

class LocalizationFeature {
  static void localizationFeature() async {
    // 1- get the string write in strings_constants.dart
    List<String> wordsToTranslate =
        await GetStringToTranslate.getStringToTranslate();

  }
}
