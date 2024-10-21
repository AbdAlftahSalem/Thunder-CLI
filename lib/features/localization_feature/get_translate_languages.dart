import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';

import '../../core/models/from_to_language_model.dart';

class GetTranslateLanguages {
  static FromToLanguageModel getTranslateLanguages() {
    FromToLanguageModel fromToLanguageModel = FromToLanguageModel("", []);
    bool andAnotherLanguage = true;

    while (fromToLanguageModel.baseLanguage.isEmpty) {
      stdout.write("Enter base language : ");
      fromToLanguageModel.baseLanguage = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage("😢 Base language is required !!");
    }

    while (andAnotherLanguage) {
      stdout.write("Enter to language : ");
      String toLanguage = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage("😢 To language is required !!");

      if (toLanguage.isNotEmpty) {
        fromToLanguageModel.toLanguages
            .add(ToLanguages(languageName: toLanguage));
        stdout.write("\nDo you want add another language ? ( y / N) : ");
        String option = (stdin.readLineSync() ?? "")
            .trim()
            .checkIfEmptyAndNullAndShowMessage(
                "😢 Dart file name for language required !!");
        if (option.toLowerCase() == "n") {
          andAnotherLanguage = false;
        }
      }
    }
    return fromToLanguageModel;
  }
}
