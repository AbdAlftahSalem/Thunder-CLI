import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';

import '../../core/models/from_to_language_model.dart';

class GetTranslateLanguages {
  static FromToLanguageModel getTranslateLanguages() {
    FromToLanguageModel fromToLanguageModel = FromToLanguageModel();

    while (fromToLanguageModel.baseLanguage.isEmpty) {
      stdout.write("Enter base language : ");
      fromToLanguageModel.baseLanguage = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage("😢 Base language is required !!");
    }

    while (fromToLanguageModel.toLanguages.isEmpty) {
      stdout.write("Enter to language/s and separate between them by (,) : ");
      String toLanguage = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage("😢 Base language is required !!");

      if (toLanguage.isNotEmpty) {
        fromToLanguageModel.toLanguages =
            toLanguage.split(",").map((e) => e.trim()).toList();
      }
    }
    return fromToLanguageModel;
  }
}
