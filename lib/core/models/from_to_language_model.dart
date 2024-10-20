class FromToLanguageModel {
  String baseLanguage;
  List<ToLanguages> toLanguages;

  FromToLanguageModel(this.baseLanguage, this.toLanguages);


}

class ToLanguages {
  String languageName;
  String languageDateFileName;

  ToLanguages({
    this.languageName = "",
    this.languageDateFileName = "",
  });
}
