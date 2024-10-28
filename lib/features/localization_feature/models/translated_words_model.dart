class TranslatedWordsModel {
  String language;
  String baseWordsString;
  String translatedWordsString;
  String fromLanguage;
  String toLanguage;

  List<String>? baseWordsList;
  List<String>? translatedWordsList;

  TranslatedWordsModel(
      {this.language = "",
      this.baseWordsString = "",
      this.translatedWordsString = "",
      this.translatedWordsList,
      this.fromLanguage = "",
      this.toLanguage = "",
      this.baseWordsList}) {
    baseWordsList = baseWordsString.split("||").map((e) => e.trim()).toList();
    translatedWordsList =
        translatedWordsString.split("||").map((e) => e.trim()).toList();
  }
}
