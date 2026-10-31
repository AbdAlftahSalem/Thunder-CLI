import '../../core/services/cmd_service/run_in_cmd.dart';
import '../../core/services/console_service/console.dart';

/// Creates the git repository and (optionally) pushes it to GitHub.
class PublishProjectToGithub {
  /// `git init`, first commit, and push to [remoteUrl] when it is not empty.
  static Future<void> publishProjectToGithub(String root,
      {String remoteUrl = '',
      String commitMessage = 'Init project with Thunder CLI'}) async {
    if (!await RunInCmd.isAvailable('git')) {
      Console.warning('git was not found, skipping the repository setup');
      return;
    }
    final steps = <List<String>>[
      ['init', '-b', 'main'],
      ['add', '.'],
      ['commit', '-m', commitMessage],
    ];
    for (final step in steps) {
      final result = await RunInCmd.run('git', step, workingDirectory: root);
      if (result.exitCode != 0) {
        Console.warning(
            'git ${step.first} failed, you can finish the git setup yourself');
        return;
      }
    }
    Console.success('Git repository created with a first commit');

    if (remoteUrl.isEmpty) return;
    await RunInCmd.run('git', ['remote', 'add', 'origin', remoteUrl],
        workingDirectory: root);
    final push = await RunInCmd.run('git', ['push', '-u', 'origin', 'main'],
        workingDirectory: root);
    if (push.exitCode == 0) {
      Console.success('Pushed to $remoteUrl');
    } else {
      Console.warning(
          'Could not push to $remoteUrl. Run "git push -u origin main" when the repository is ready.');
    }
  }
}
