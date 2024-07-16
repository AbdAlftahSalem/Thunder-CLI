import 'dart:io';

import 'package:thunder_cli/extensions/string_extensions.dart';
import 'package:thunder_cli/models/app_data_model.dart';
import 'package:thunder_cli/services/create_folder_files.dart';

import '../consts/const.dart';
import '../consts/folder_paths.dart';
import '../services/run_cmd.dart';

class InitFolders {
  Future<void> initFolders() async {
    try {
      final AppDataModel appInfo = await _getUserApplicationData();

      final dirName = appInfo.appName;

      print(
          "\n\n🔃🔃 Thunder will initialize your app. Please wait for seconds");

      final ProcessResult processResult = await _cloneRepository(
          appInfo.stateManagement.toString().getRepoUrl(), dirName);

      if (processResult.exitCode == 0) {
        bool setupResult = await _setupClonedProject(appInfo);

        if (setupResult) {
          print('⚡ Init app successfully 🎉\n');

          await _publishToGitHub();

          await openInVSCode();
        } else {
          print('😅 An error occurred during project setup.');
        }
      } else {
        print(
            '😅 Failed to clone the repository.\n Exit code : ${processResult.exitCode}\n Error : ${processResult.stderr}');
      }
    } catch (e) {
      print('😅 An error occurred: $e');
    }
  }

  Future<AppDataModel> _getUserApplicationData() async {
    AppDataModel appDataModel = AppDataModel();

    while (appDataModel.appName.isEmpty) {
      stdout.write('😎 Enter your application name: ');
      appDataModel.appName = (stdin
                  .readLineSync()
                  ?.trim()
                  .replaceAll(" ", "_")
                  .toLowerCase() ??
              "")
          .checkIfEmptyAndShowMessage("😢 Application name cannot be empty");
    }

    while (appDataModel.packageName.isEmpty ||
        (appDataModel.packageName.split(".").length == 1)) {
      stdout.write('😎 Enter your package name: ');
      appDataModel.packageName =
          (stdin.readLineSync()?.trim().replaceAll(" ", "_").toLowerCase() ??
                  "")
              .checkIfEmptyAndShowMessage("😢 Package name cannot be empty");
    }

    while (appDataModel.stateManagement.isEmpty) {
      stdout.write('😎 Enter your state management [ GetX / BloC ]: ');
      final stateManagement = stdin.readLineSync()?.trim() ?? "";
      if (stateManagement.toLowerCase() == 'getx') {
        appDataModel.stateManagement = "GetX";
      } else if (stateManagement.toLowerCase() == 'bloc') {
        appDataModel.stateManagement = 'BloC';
      }
    }

    stdout
        .write('😎 Do you want to using GitHubActions ? (y , N)[ default y ] ');
    appDataModel.usingGitHubAction =
        (stdin.readLineSync()?.trim() ?? "").toLowerCase() == 'n'
            ? false
            : true;

    if (appDataModel.usingGitHubAction) {
      print(
          "\n⚡⚡ THUNDER WILL ADD GITHUB ACTION TO SEND APK FILE TO TELEGRAM GROUP AUTOMATICALLY\n** BUT YOU SHOULD MAKE SOME STEPS\n** FOLLOW THIS LINK : \n\n");
      CreateFolderAndFiles().createFolder(Directory.current.path);
      CreateFolderAndFiles().createFolder("${Directory.current.path}\\.github");
      CreateFolderAndFiles()
          .createFolder("${Directory.current.path}\\.github\\workflows");

      CreateFolderAndFiles().createFile("${Directory.current.path}\\.github\\workflows\\build_flutter_apk_and_send_to_telegram.yaml",
          ConstStrings.instance.buildApkFileWorkFlow());

      print("✅ Finished setup GitHub Action successfully 🎉 ...");
    }

    stdout.write('😎 Do you want to using App flavors ? (y , N)[ default y ] ');
    appDataModel.usingFlavors =
        (stdin.readLineSync()?.trim() ?? "").toLowerCase() == 'n'
            ? false
            : true;

    if (appDataModel.usingFlavors) {
      print("⚡ Thunder will setup flavors in ${appDataModel.appName}");
      // TODO : Setup flavors
      print("✅ Finished setup flavors successfully 🎉 ...");
      print("You can know about Flavors in this link : ");
    }

    return appDataModel;
  }

  Future<ProcessResult> _cloneRepository(String repoUrl, String dirName) async {
    final cloneProcess = await Process.run('git', ['clone', repoUrl, dirName]);
    print(
        "⚡⚡ Cloning repository completed with exit code ${cloneProcess.exitCode}\n");
    return cloneProcess;
  }

  Future<bool> _setupClonedProject(AppDataModel appInfo) async {
    if (await _navigateToClonedDirectory(appInfo.appName)) {
      CreateFolderAndFiles()
          .createFile(FolderPaths.instance.jsonFile, appInfo.toJson());
      await _runFlutterPubGet();
      await _changePackageName(appInfo.packageName);
      await _changeAppName(appInfo.appName);

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

  Future<void> openInVSCode() async {
    stdout.write('😎 Do you want to open the project in VSCode? (y/N): ');
    final openInVSCode = stdin.readLineSync()?.trim().toLowerCase() ?? "";
    if (openInVSCode == 'y') {
      print('⚡ Opening project in VSCode...');
      await Process.run('code', ['.'],
          runInShell: true, workingDirectory: Directory.current.path);
      ;
    }
  }

  Future<bool> _askToPublishToGitHub() async {
    stdout.write('😎 Do you want to publish the project to GitHub? (y/N): ');
    final publishToGitHub = stdin.readLineSync()?.trim().toLowerCase() ?? "";
    return publishToGitHub == 'y';
  }

  Future<void> _publishToGitHub() async {
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
}
