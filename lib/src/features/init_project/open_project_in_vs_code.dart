import '../../core/services/cmd_service/run_in_cmd.dart';
import '../../core/services/console_service/console.dart';

/// Opens the new project in VS Code.
class OpenProjectInVSCode {
  /// Runs `code <root>`.
  static Future<void> openProjectInVSCode(String root) async {
    Console.step('Opening project in VS Code ...');
    final result = await RunInCmd.run('code', [root], showErrors: false);
    if (result.exitCode != 0) {
      Console.warning('Could not start VS Code ("code" command not found)');
    }
  }
}
