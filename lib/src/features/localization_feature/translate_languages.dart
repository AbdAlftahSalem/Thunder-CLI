import 'package:translator/translator.dart';

import '../../core/services/console_service/console.dart';

/// Signature of a function that translates [texts] and returns one result
/// per text (`null` when that text could not be translated).
typedef Translate = Future<List<String?>> Function(List<String> texts,
    {required String from, required String to});

/// Translates texts with Google Translate (through the `translator` package).
class TranslateLanguages {
  /// Translates every text of [texts] from [from] to [to].
  static Future<List<String?>> translate(List<String> texts,
      {required String from, required String to}) async {
    final translator = GoogleTranslator();
    final result = <String?>[];
    for (final text in texts) {
      String? translated;
      for (var attempt = 0; attempt < 3 && translated == null; attempt++) {
        try {
          translated =
              (await translator.translate(text, from: from, to: to)).text;
        } catch (e) {
          if (attempt == 2) Console.warning('Could not translate "$text": $e');
          await Future<void>.delayed(
              Duration(milliseconds: 400 * (attempt + 1)));
        }
      }
      result.add(translated);
    }
    return result;
  }
}
