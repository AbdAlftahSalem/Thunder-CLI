import '../consts/const.dart';

extension StringCamelCaseConversion on String {
  String toCamelCase() {
    List<String> words = split('_');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      words[i] = word.substring(0, 1).toUpperCase() + word.substring(1);
    }
    return words.join();
  }

  String lowerCaseFirstLetter() {
    return "${this[0].toLowerCase()}${substring(1)}";
  }

  String getRepoUrl() {
    if (toLowerCase() == "getx") return ConstStrings.instance.repoGetXUrl;
    if (toLowerCase() == "bloc") return ConstStrings.instance.repoBloCUrl;
    return ConstStrings.instance.repoGetXUrl;
  }
}

extension ValidateInputData on String? {
  String checkIfEmptyAndShowMessage(message) {
    if ((this ?? "").isEmpty || this == null) {
      return '';
    }
    return this ?? "";
  }
}
