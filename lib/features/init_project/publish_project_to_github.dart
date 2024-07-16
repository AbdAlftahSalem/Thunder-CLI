import 'dart:io';

import '../../services/run_cmd.dart';

class PublishProjectToGithub {
  static Future<void> publishProjectToGithub() async {
    bool publishToGitHub = await _askToPublishToGitHub();

    if (publishToGitHub) {
      // get user repository url
      stdout.write('😎 Enter your repository url: ');
      final repoUrl = stdin.readLineSync()?.trim() ?? "";

      // get user  repository commit message [ by default is init project ]
      stdout.write(
          '😎 Enter your repository commit message [ by default is init project ]: ');
      final repoCommitMessage = stdin.readLineSync()?.trim() ?? "init project";

      await RunCmd.runInCmd('git init');
      await RunCmd.runInCmd('git add .');
      await RunCmd.runInCmd('git commit -m "$repoCommitMessage"');
      await RunCmd.runInCmd('git branch -M main');
      await RunCmd.runInCmd('git remote add origin $repoUrl');
      await RunCmd.runInCmd('git push -u origin main');

      print("⚡⚡ Publish to GitHub completed successfully\n");
      print("🔗🔗 Repo link: $repoUrl\n");
    }
  }

  static Future<bool> _askToPublishToGitHub() async {
    stdout.write('😎 Do you want to publish the project to GitHub? (y/N): ');
    final publishToGitHub = stdin.readLineSync()?.trim().toLowerCase() ?? "";
    return publishToGitHub == 'y';
  }
}
