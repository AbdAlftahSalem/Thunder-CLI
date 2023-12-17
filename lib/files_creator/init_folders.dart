import 'dart:io';

import 'package:thunder_cli/extensions/string_extensions.dart';
import 'package:thunder_cli/services/create_folder_files.dart';

import '../services/run_cmd.dart';

class InitFolders {
  Future<void> initFolders() async {
    try {
      final appInfo = await _getUserApplicationData();

      final dirName = appInfo['appName'] ?? "thunder_application";

      print(
          "\n\n🔃🔃 Thunder will initialize your app. Please wait for seconds");

      final cloneExitCode = await _cloneRepository(
          appInfo["stateManagement"].toString().getRepoUrl(), dirName);

      if (cloneExitCode == 0) {
        final success = await _setupClonedProject(appInfo);

        if (success) {
          print('⚡ Init app successfully\n');

          await _publishToGitHub();

          final openInVSCode = await _askToOpenInVSCode();

          if (openInVSCode) {
            print('⚡ Opening project in VSCode...');
            await _openInVSCode();
          }
        } else {
          print('😅 An error occurred during project setup.');
        }
      } else {
        print('😅 Failed to clone the repository.');
      }
    } catch (e) {
      print('😅 An error occurred: $e');
    }
  }

  Future<Map<String, String>> _getUserApplicationData() async {
    stdout.write('😎 Enter your application name: ');
    final appName =
        stdin.readLineSync()?.trim().replaceAll(" ", "_").toLowerCase() ?? "";

    if (appName.isEmpty) {
      print('😢 Application name cannot be empty');
      return {};
    }

    stdout.write('😎 Enter your package name: ');
    final packageName = stdin.readLineSync()?.trim() ?? "";

    if (packageName.isEmpty) {
      print('😢 Package name cannot be empty');
      return {};
    }

    stdout.write('😎 Enter your state management [ GetX / BloC / Provider ]: ');
    final stateManagement = stdin.readLineSync()?.trim() ?? "";

    if (stateManagement.isEmpty) {
      print('😢 State management cannot be empty');
      return {};
    }

    return {
      'appName': appName,
      'packageName': packageName,
      'stateManagement': stateManagement,
    };
  }

  Future<int> _cloneRepository(String repoUrl, String dirName) async {
    final cloneProcess = await Process.run('git', ['clone', repoUrl, dirName]);
    print(
        "⚡⚡ Cloning repository completed with exit code ${cloneProcess.exitCode}\n");
    return cloneProcess.exitCode;
  }

  Future<bool> _setupClonedProject(Map<String, String> appInfo) async {
    if (await _navigateToClonedDirectory(appInfo['appName'] ?? "")) {
      CreateFolderAndFiles().createFile("thunder.json", appInfo);
      await _runFlutterPubGet();
      await _changePackageName(
          appInfo['packageName'] ?? "com.example.thunder_cli");
      await _changeAppName(appInfo['appName'] ?? "");

      // remove .git folder from cloned project
      await RunCmd.runInCmd('rd /s /q .git');

      return true;
    }
    return false;
  }

  Future<bool> _navigateToClonedDirectory(String dirName) async {
    final clonedDirectory = Directory(dirName);
    if (clonedDirectory.existsSync()) {
      Directory.current = clonedDirectory;
      return true;
    }
    return false;
  }

  Future<void> _runFlutterPubGet() async {
    print("🔃🔃 Start initializing your app. Please wait for seconds");
    final pubGetProcess = await Process.run('flutter', ['pub', 'get'],
        runInShell: true, workingDirectory: Directory.current.path);

    if (pubGetProcess.exitCode == 0) {
      print('⚡ Flutter pub get completed successfully.');
    } else {
      print('😅 Failed to run "flutter pub get". You can run it manually');
    }

    print("⚡⚡ Pub get completed with exit code ${pubGetProcess.exitCode}\n");
  }

  Future<void> _changePackageName(String packageName) async {
    await Process.run(
        'flutter', ['pub', 'run', 'change_app_package_name:main', packageName],
        runInShell: true, workingDirectory: Directory.current.path);
    print("⚡⚡ Change package name completed successfully\n");
  }

  Future<void> _changeAppName(String appName) async {
    await Process.run(
        'flutter', ['pub', 'run', 'rename_app:main', 'all=$appName'],
        runInShell: true, workingDirectory: Directory.current.path);
    print("⚡⚡ Change app name completed successfully\n");
  }

  Future<bool> _askToOpenInVSCode() async {
    stdout.write('😎 Do you want to open the project in VSCode? (y/N): ');
    final openInVSCode = stdin.readLineSync()?.trim().toLowerCase() ?? "";
    return openInVSCode == 'y';
  }

  Future<bool> _askToPublishToGitHub() async {
    stdout.write('😎 Do you want to publish the project to GitHub? (y/N): ');
    final publishToGitHub = stdin.readLineSync()?.trim().toLowerCase() ?? "";
    return publishToGitHub == 'y';
  }

  Future<void> _openInVSCode() async {
    await Process.run('code', ['.'],
        runInShell: true, workingDirectory: Directory.current.path);
  }

  Future<void> _publishToGitHub() async {
    final publishToGitHub = await _askToPublishToGitHub();

    if (publishToGitHub) {
      // get user repository url
      stdout.write('😎 Enter your repository url: ');
      final repoUrl = stdin.readLineSync()?.trim() ?? "";

      // get user repository commit message [ by default is init project ]
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
}
