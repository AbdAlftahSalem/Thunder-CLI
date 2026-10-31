import '../../core/extensions/string_extensions.dart';

/// Reads and writes the files used by GetX translations.
class LocalizationFiles {
  /// Reads `static const String hello = "Hello";` lines from
  /// `strings_constants.dart`. Returns variable name => text.
  static Map<String, String> readStringsConstants(String content) {
    final result = <String, String>{};
    final pattern = RegExp(
        r'''static\s+const\s+(?:String\s+)?(\w+)\s*=\s*(?:"((?:[^"\\]|\\.)*)"|'((?:[^'\\]|\\.)*)')\s*;''');
    for (final m in pattern.allMatches(content)) {
      result[m[1]!] = _unescape(m[2] ?? m[3] ?? '');
    }
    return result;
  }

  /// Reads `StringsConstants.hello: "مرحبا",` entries of a translation file.
  /// Returns variable name => translated text.
  static Map<String, String> readTranslationFile(String content) {
    final result = <String, String>{};
    final pattern = RegExp(
        r'''StringsConstants\.(\w+)\s*:\s*(?:"((?:[^"\\]|\\.)*)"|'((?:[^'\\]|\\.)*)')''');
    for (final m in pattern.allMatches(content)) {
      result[m[1]!] = _unescape(m[2] ?? m[3] ?? '');
    }
    return result;
  }

  /// Dart variable holding the translations of [language] (`arLanguage`).
  static String variableName(String language) =>
      '${language.toCamelCase()}Language';

  /// Content of `<language>_translation.dart`, in the order of [keys].
  static String translationFile(
      String language, List<String> keys, Map<String, String> translations) {
    final b = StringBuffer()
      ..writeln("import '../constants/strings_constants.dart';")
      ..writeln()
      ..writeln('final Map<String, String> ${variableName(language)} = {');
    for (final key in keys) {
      final value = translations[key];
      if (value == null) continue;
      b.writeln('  StringsConstants.$key: "${_escape(value)}",');
    }
    b.writeln('};');
    return b.toString();
  }

  /// Content of `local.dart` with every language in [languages] plus the
  /// languages already registered in the [existing] file.
  static String localFile(List<String> languages, {String existing = ''}) {
    final all = <String>[
      ...RegExp(r"^import '(\w+)_translation\.dart';", multiLine: true)
          .allMatches(existing)
          .map((m) => m[1]!),
    ];
    for (final language in languages) {
      if (!all.contains(language.toSnakeCase())) {
        all.add(language.toSnakeCase());
      }
    }
    final b = StringBuffer()
      ..writeln("import 'package:get/get.dart';")
      ..writeln();
    for (final l in all) {
      b.writeln("import '${l}_translation.dart';");
    }
    b
      ..writeln()
      ..writeln(
          '/// GetX translations. `thunder localization` adds new languages here.')
      ..writeln('class MyLocal implements Translations {')
      ..writeln('  @override')
      ..writeln('  Map<String, Map<String, String>> get keys => {');
    for (final l in all) {
      b.writeln("        '${_localeKey(l)}': ${variableName(l)},");
    }
    b
      ..writeln('      };')
      ..writeln('}');
    return b.toString();
  }

  /// GetX locale key: `zh_cn` => `zh_CN`, `ar` => `ar`.
  static String _localeKey(String language) {
    final parts = language.split('_');
    if (parts.length == 1) return parts.first;
    return '${parts.first}_${parts.sublist(1).join('_').toUpperCase()}';
  }

  static String _escape(String value) => value
      .replaceAll(r'\', r'\\')
      .replaceAll('"', r'\"')
      .replaceAll(r'$', r'\$')
      .replaceAll('\n', r'\n');

  static String _unescape(String value) => value
      .replaceAll(r'\"', '"')
      .replaceAll(r"\'", "'")
      .replaceAll(r'\$', r'$')
      .replaceAll(r'\n', '\n')
      .replaceAll(r'\\', r'\');
}
