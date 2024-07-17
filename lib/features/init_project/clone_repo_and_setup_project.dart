import 'dart:io';

import 'package:thunder_cli/core/helper/extensions/string_extensions.dart';
import 'package:thunder_cli/core/helper/services/folder_and_file_service/create_file.dart';
import 'package:thunder_cli/features/init_project/publish_project_to_github.dart';

import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/cmd_service/run_in_cmd.dart';
import '../../core/models/app_data_model.dart';
import 'open_project_in_vs_code.dart';

class CloneRepoAndSetupProject {
  static void cloneAndSetupProject(
      {required AppDataModel appInfo, required String dirName}) async {
    print("\n\n🔃🔃 Thunder will initialize your app. Please wait for seconds");

    final ProcessResult processResult =
        await CloneRepoAndSetupProject._cloneRepo(
      repoUrl: appInfo.stateManagement.toString().getRepoUrl(),
      dirName: dirName,
    );

    if (processResult.exitCode == 0) {
      bool setupResult =
          await CloneRepoAndSetupProject._setupClonedProject(appInfo);

      if (setupResult) {
        print('⚡ Init app successfully 🎉\n');

        await PublishProjectToGithub.publishProjectToGithub();

        await OpenProjectInVSCode.openProjectInVSCode();
      } else {
        print('😅 An error occurred during project setup.');
      }
    } else {
      print(
          '😅 Failed to clone the repository.\n Exit code : ${processResult.exitCode}\n Error : ${processResult.stderr}');
    }
  }

  static Future<ProcessResult> _cloneRepo(
      {required String repoUrl, required String dirName}) async {
    final cloneProcess = await Process.run('git', ['clone', repoUrl, dirName]);
    print(
        "⚡⚡ Cloning repository completed with exit code ${cloneProcess.exitCode}\n");
    return cloneProcess;
  }

  static Future<bool> _setupClonedProject(AppDataModel appInfo) async {
    if (await _navigateToClonedDirectory(appInfo.appName)) {
      CreateFile.createFile(FolderPaths.instance.jsonFile, appInfo.toJson());
      await _runFlutterPubGet();
      await _changePackageName(appInfo.packageName);
      await _changeAppName(appInfo.appName);

      // remove .git folder from cloned project
      await RunInCmd.runInCmd('rd /s /q .git');

      return true;
    }
    return false;
  }

  static Future<bool> _navigateToClonedDirectory(String dirName) async {
    final clonedDirectory = Directory(dirName);
    if (clonedDirectory.existsSync()) {
      Directory.current = clonedDirectory;
      return true;
    }
    return false;
  }

  static Future<void> _runFlutterPubGet() async {
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

  static Future<void> _changePackageName(String packageName) async {
    await Process.run(
        'flutter', ['pub', 'run', 'change_app_package_name:main', packageName],
        runInShell: true, workingDirectory: Directory.current.path);
    print("⚡⚡ Change package name completed successfully\n");
  }

  static Future<void> _changeAppName(String appName) async {
    await Process.run(
        'flutter', ['pub', 'run', 'rename_app:main', 'all=$appName'],
        runInShell: true, workingDirectory: Directory.current.path);
    print("⚡⚡ Change app name completed successfully\n");
  }
}
