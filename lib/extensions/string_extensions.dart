extension StringCamelCaseConversion on String {
  String toCamelCase() {
    List<String> words = split('_');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      words[i] = word.substring(0, 1).toUpperCase() + word.substring(1);
    }
    return words.join();
  }
}
