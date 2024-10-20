class FromToLanguageModel {
  String baseLanguage;
  List<ToLanguages> toLanguages;

  FromToLanguageModel(this.baseLanguage, this.toLanguages);


}

class ToLanguages {
  String languageName;
  String languageDartFileName;

  ToLanguages({
    this.languageName = "",
    this.languageDartFileName = "",
  });
}
