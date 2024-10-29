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
      'language_name': languageName,
      'language_dart_file_name': languageDartFileName,
    };
  }

  factory ToLanguages.fromMap(Map<String, dynamic> map) {
    return ToLanguages(
      languageName: map['language_name'] as String,
      languageDartFileName: map['language_dart_file_name'] as String,
    );
  }

  @override
  String toString() {
    return 'language name: $languageName';
  }
}
