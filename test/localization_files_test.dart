import 'package:test/test.dart';
import 'package:thunder_cli/thunder_cli.dart';

void main() {
  group('LocalizationFiles', () {
    test('reads strings_constants.dart', () {
      const content = r"""
class StringsConstants {
  static const String home = "Home";
  static const login = 'Log in';
  static const String welcome = "Welcome \"$name\"";
}
""";
      expect(LocalizationFiles.readStringsConstants(content), {
        'home': 'Home',
        'login': 'Log in',
        'welcome': r'Welcome "$name"',
      });
    });

    test('writes and reads back a translation file', () {
      final file = LocalizationFiles.translationFile('ar', ['home', 'welcome'],
          {'home': 'الرئيسية', 'welcome': r'أهلا "$name"'});
      expect(file, contains('final Map<String, String> arLanguage = {'));
      expect(file, contains(r'StringsConstants.welcome: "أهلا \"\$name\"",'));
      expect(LocalizationFiles.readTranslationFile(file),
          {'home': 'الرئيسية', 'welcome': r'أهلا "$name"'});
    });

    test('local.dart keeps existing languages', () {
      final first = LocalizationFiles.localFile(['en', 'ar']);
      final second = LocalizationFiles.localFile(['en', 'fr'], existing: first);
      expect(second, contains("'ar': arLanguage,"));
      expect(second, contains("'fr': frLanguage,"));
      expect(second, contains("import 'en_translation.dart';"));
      expect(RegExp("'en': enLanguage").allMatches(second).length, 1);
    });
  });
}
