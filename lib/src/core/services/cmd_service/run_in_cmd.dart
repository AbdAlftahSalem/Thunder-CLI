import 'dart:io';

/// Runs external tools (`flutter`, `git`, `code` ...) on every platform.
class RunInCmd {
  /// Runs [executable] with [arguments] and returns the result.
  ///
  /// On Windows the command runs inside a shell so `flutter.bat` and
  /// `code.cmd` are found. Errors are printed when [showErrors] is `true`.
  static Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    bool showErrors = true,
  }) async {
    try {
      final result = await Process.run(
        executable,
        arguments,
        workingDirectory: workingDirectory,
        runInShell: Platform.isWindows,
      );
      if (result.exitCode != 0 && showErrors) {
        stderr.writeln('   $executable ${arguments.join(' ')}');
        stderr.writeln('   Exit code : ${result.exitCode}');
        final err = result.stderr.toString().trim();
        final out = result.stdout.toString().trim();
        if (err.isNotEmpty) stderr.writeln('   $err');
        if (err.isEmpty && out.isNotEmpty) stderr.writeln('   $out');
      }
      return result;
    } on ProcessException catch (e) {
      if (showErrors) {
        stderr.writeln('   Could not run "$executable": ${e.message}');
      }
      return ProcessResult(0, 127, '', e.message);
    }
  }

  /// Returns `true` when [executable] can be started (for example `flutter`).
  static Future<bool> isAvailable(String executable) async {
    final result = await run(executable, ['--version'], showErrors: false);
    return result.exitCode == 0;
  }
}
