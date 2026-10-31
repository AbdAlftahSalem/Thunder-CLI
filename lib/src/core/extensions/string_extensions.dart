import '../../features/convert_api_collection_to_code/models/variable_model.dart';

/// Dart reserved words and built-in identifiers that can not be used as
/// field or method names in generated code.
const Set<String> dartReservedWords = {
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'Function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'type',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
};

/// String helpers used to turn user input (feature names, JSON keys, API
/// request names) into valid Dart names.
extension StringConversion on String {
  /// Splits a name written in any style into lower-case words.
  ///
  /// `user_profile`, `user-profile`, `user profile`, `UserProfile` and
  /// `userProfile` all become `[user, profile]`.
  List<String> get words {
    final spaced = replaceAllMapped(
      RegExp(r'([a-z0-9])([A-Z])'),
      (m) => '${m[1]} ${m[2]}',
    );
    return spaced
        .split(RegExp(r'[^A-Za-z0-9]+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word.toLowerCase())
        .toList();
  }

  /// Converts to PascalCase. Ex : contact_us => ContactUs
  String toCamelCaseFirstLetterForEachWord() {
    return words
        .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
        .join();
  }

  /// Lower the first letter in word . Ex : ContactUs => contactUs
  String lowerCaseFirstLetter() {
    if (isEmpty) return this;
    return "${this[0].toLowerCase()}${substring(1)}";
  }

  /// Converts to camelCase. Ex : contact_us => contactUs
  String toCamelCase() =>
      toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter();

  /// Converts to snake_case. Ex : ContactUs => contact_us
  String toSnakeCase() => words.join('_');

  /// Converts to SCREAMING_SNAKE_CASE. Ex : contactUs => CONTACT_US
  String toConstantCase() => toSnakeCase().toUpperCase();

  /// Converts any string (for example a JSON key) to a valid Dart identifier
  /// in camelCase. Reserved words get a `Value` suffix and names that start
  /// with a digit get a `field` prefix.
  String toDartIdentifier() {
    var name = toCamelCase();
    if (name.isEmpty) name = 'field';
    if (RegExp(r'^[0-9]').hasMatch(name)) name = 'field$name';
    if (dartReservedWords.contains(name)) name = '${name}Value';
    return name;
  }

  /// Converts any string to a valid Dart class name in PascalCase.
  String toDartClassName() {
    var name = toCamelCaseFirstLetterForEachWord();
    if (name.isEmpty) name = 'Unnamed';
    if (RegExp(r'^[0-9]').hasMatch(name)) name = 'Model$name';
    return name;
  }

  /// Escapes a value so it can be placed inside a single quoted Dart string.
  String escapeForDartString() {
    return replaceAll(r'\', r'\\')
        .replaceAll("'", r"\'")
        .replaceAll(r'$', r'\$')
        .replaceAll('\n', r'\n');
  }

  /// Replaces every Postman `{{variable}}` with its value from [vars].
  /// Unknown variables are left untouched.
  String convertVariableToValue(List<VariableModel> vars) {
    return replaceAllMapped(RegExp(r'\{\{\s*([^{}]+?)\s*\}\}'), (match) {
      final key = match[1]!;
      for (final variable in vars) {
        if (variable.key.toLowerCase() == key.toLowerCase()) {
          return variable.value;
        }
      }
      return match[0]!;
    });
  }

  /// Makes sure the string ends with `/`.
  String updateSlashInUrl() {
    if (!endsWith("/")) {
      return '$this/';
    }
    return this;
  }
}

/// Helpers for nullable input read from the terminal.
extension ValidateInputData on String? {
  /// check if String? is empty and null then return empty string . else return the same string
  String checkIfEmptyAndNullAndShowMessage(String message) {
    if (this == null || this!.trim().isEmpty) {
      print("$message\n");
      return "";
    }
    return this!;
  }
}
