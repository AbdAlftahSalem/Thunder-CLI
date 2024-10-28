class FromToLanguageModel {
  String baseLanguage;
  List<ToLanguages> toLanguages;

  FromToLanguageModel(this.baseLanguage, this.toLanguages);
}

class ToLanguages {
  String languageName;
  String languageDartFileName;

  ToLanguages({this.languageName = "", this.languageDartFileName = ""}) {
    languageDartFileName = "${languageName.substring(0, 2)}_translation.dart";
  }

  Map<String, dynamic> toMap() {
    return {
      'languageName': languageName,
      'languageDartFileName': languageDartFileName,
    };
  }

  factory ToLanguages.fromMap(Map<String, dynamic> map) {
    return ToLanguages(
      languageName: map['languageName'] as String,
      languageDartFileName: map['languageDartFileName'] as String,
    );
  }
}
