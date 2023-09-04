import 'dart:io';

class RunCmd {
  static runInCmd(String command) {
    Process.run(command, [], runInShell: true).then((ProcessResult result) {
      print(result.stdout);
      // Handle any errors
      if (result.exitCode != 0) {
        print('Error: ${result.stderr}');
      }
    });
  }
}
