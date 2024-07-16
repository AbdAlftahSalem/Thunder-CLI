import 'dart:io';

class OpenProjectInVSCode {
  static Future<void> openProjectInVSCode() async {
    stdout.write('😎 Do you want to open the project in VSCode? (y/N): ');
    final openInVSCode = stdin.readLineSync()?.trim().toLowerCase() ?? "";
    if (openInVSCode == 'y') {
      print('⚡ Opening project in VSCode...');
      await Process.run('code', ['.'],
          runInShell: true, workingDirectory: Directory.current.path);
    }
  }
}
