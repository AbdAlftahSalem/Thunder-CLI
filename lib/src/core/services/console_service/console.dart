import 'dart:io';

/// Small wrapper around stdin/stdout so every command prints and asks
/// questions the same way.
///
/// When the terminal is not interactive (CI, pipes) or `--yes` is passed,
/// questions return their default value instead of waiting for input.
class Console {
  /// When `true`, [ask] and [confirm] never read from stdin.
  static bool nonInteractive = false;

  static bool get _canAsk => !nonInteractive && stdin.hasTerminal;

  /// Prints a normal line.
  static void info(String message) => stdout.writeln(message);

  /// Prints a success line.
  static void success(String message) => stdout.writeln('✅ $message');

  /// Prints a step line.
  static void step(String message) => stdout.writeln('⚡ $message');

  /// Prints a warning line.
  static void warning(String message) => stdout.writeln('⚠️  $message');

  /// Prints an error line to stderr.
  static void error(String message) => stderr.writeln('😢 $message');

  /// Asks a question and returns the trimmed answer, or [defaultValue] when
  /// the answer is empty or the terminal is not interactive.
  static String ask(String question, {String defaultValue = ''}) {
    if (!_canAsk) return defaultValue;
    final suffix = defaultValue.isEmpty ? '' : ' [ $defaultValue ]';
    stdout.write('😎 $question$suffix : ');
    final answer = stdin.readLineSync()?.trim() ?? '';
    return answer.isEmpty ? defaultValue : answer;
  }

  /// Returns [given] when it is not null (the value passed as an option),
  /// otherwise asks with [askValid]. Throws [ArgumentError] when [given] is
  /// not valid.
  static String valueOrAsk(
    String? given,
    String question, {
    required String? Function(String value) validate,
    String defaultValue = '',
  }) {
    if (given != null) {
      final error = validate(given);
      if (error != null) throw ArgumentError(error);
      return given;
    }
    return askValid(question, validate: validate, defaultValue: defaultValue);
  }

  /// Asks until [validate] returns `null` (no error). In non-interactive mode
  /// the [defaultValue] is validated once and an [ArgumentError] is thrown
  /// when it is not valid.
  static String askValid(
    String question, {
    required String? Function(String value) validate,
    String defaultValue = '',
  }) {
    if (!_canAsk) {
      final error = validate(defaultValue);
      if (error != null) throw ArgumentError(error);
      return defaultValue;
    }
    while (true) {
      final value = ask(question, defaultValue: defaultValue);
      final error = validate(value);
      if (error == null) return value;
      Console.error(error);
    }
  }

  /// Asks a yes / no question.
  static bool confirm(String question, {bool defaultValue = false}) {
    if (!_canAsk) return defaultValue;
    stdout.write('😎 $question ${defaultValue ? '(Y/n)' : '(y/N)'} : ');
    final answer = (stdin.readLineSync() ?? '').trim().toLowerCase();
    if (answer.isEmpty) return defaultValue;
    return answer == 'y' || answer == 'yes';
  }
}
