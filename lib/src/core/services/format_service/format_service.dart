import '../cmd_service/run_in_cmd.dart';
import '../project_service/project_service.dart';

/// Formats generated files with `dart format` so they look hand written.
class FormatService {
  /// Runs `dart format` on [paths] (relative to the project root).
  /// Does nothing (and prints nothing) when `dart` is not available.
  static Future<void> format(ProjectService project, List<String> paths) async {
    if (paths.isEmpty) return;
    await RunInCmd.run('dart', ['format', ...paths],
        workingDirectory: project.root, showErrors: false);
  }
}
