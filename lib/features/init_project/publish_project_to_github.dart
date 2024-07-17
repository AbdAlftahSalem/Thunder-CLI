import 'dart:io';

import '../../core/helper/services/cmd_service/run_in_cmd.dart';

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

      await RunInCmd.runInCmd('git init');
      await RunInCmd.runInCmd('git add .');
      await RunInCmd.runInCmd('git commit -m "$repoCommitMessage"');
      await RunInCmd.runInCmd('git branch -M main');
      await RunInCmd.runInCmd('git remote add origin $repoUrl');
      await RunInCmd.runInCmd('git push -u origin main');

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
