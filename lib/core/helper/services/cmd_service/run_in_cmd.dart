import 'dart:io';

class RunInCmd {
  /// Run command in CMD
  static runInCmd(String command) async {
    ProcessResult result = await Process.run(command, [], runInShell: true);

    if (result.exitCode != 0) {
      print("Exit Code :  ${result.exitCode}");
      print("Error     : ${result.stderr}");
    }
  }
}
