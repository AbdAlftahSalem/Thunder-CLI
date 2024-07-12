import 'dart:io';

class RunCmd {
  static runInCmd(String command) async {
    ProcessResult result = await Process.run(command, [], runInShell: true);

    if (result.exitCode != 0) {
      print("Exit Code :  ${result.exitCode}");
      print("Error     : ${result.stderr}");
    }
  }
}
