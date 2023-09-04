import 'dart:io';

class RunCmd {
  static runInCmd(String command) async {
    ProcessResult result = await Process.run(command, [], runInShell: true);
    print(result.exitCode);
    print(result.stderr);
    print(result.stdout);
  }
}
