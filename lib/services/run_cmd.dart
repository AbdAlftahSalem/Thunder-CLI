import 'dart:io';

class RunCmd {
  static runInCmd(String command) async {
    await Process.run(command, [], runInShell: true);
  }
}
