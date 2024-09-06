import 'package:thunder_cli/core/models/variable_model.dart';

import '../consts/const_strings.dart';

extension StringConversion on String {
  /// convert String with lower case to upper case word . Ex : contact_us => ContactUs
  String toCamelCaseFirstLetterForEachWord() {
  if (isNotEmpty) {
    List<String> words = split('_');
    words.removeWhere((element) => words.isEmpty);
    try{
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      words[i] = word.substring(0, 1).toUpperCase() + word.substring(1);
    }
    }catch(e){
      // print("😢 Thunder get error in $this key");
    }
    return words.join();
  }
  return this;

  }

  /// lower the first letter in word . Ex : ContactUs => contactUs
  String lowerCaseFirstLetter() {
    return "${this[0].toLowerCase()}${substring(1)}";
  }

  /// get repository URL direct
  String getRepoUrl() {
    if (toLowerCase() == "getx") return ConstStrings.instance.repoGetXUrl;
    if (toLowerCase() == "bloc") return ConstStrings.instance.repoBloCUrl;
    return ConstStrings.instance.repoGetXUrl;
  }

  /// extract variables [ API collection ]  form string
  String convertVariableToValue(List<VariableModel> vars) {
    List<String> nameList = split(" ");
    for (String i in nameList) {
      if (i.startsWith("{{") && i.endsWith("}}")) {
        int index = nameList.indexWhere((element) => element.contains(i));
        nameList[index] = vars
            .firstWhere((element) =>
                element.key.toLowerCase() ==
                i.replaceAll("{{", "").replaceAll("}}", ""))
            .value;
      }
    }
    return nameList.join(" ");
  }

  String updateSlashInUrl(){
    if (!endsWith("/")){
      return '$this/';
    }
    return this;
  }
}

extension ValidateInputData on String? {
  /// check if String? is empty and null then return empty string . else return the same string
  String checkIfEmptyAndNullAndShowMessage(message) {
    if ((this ?? "").isEmpty || this == null) {
      print("$message\n");
      return "";
    }
    return this ?? "";
  }
}
