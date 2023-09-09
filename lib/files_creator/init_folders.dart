import 'dart:io';

class InitFolders {
  Future<void> initFolders({bool setUpPackage = false}) async {
    try {
      final appInfo = await _getUserApplicationData();
      final repoUrl =
          "https://github.com/abdAlftahSalem/flutter_getx_template.git";
      final dirName = appInfo['appName'] ?? "";

      print("Thunder will initialize your app. Please wait for seconds 🔃");

      if (await _cloneRepository(repoUrl, dirName) == 0) {
        if (await _navigateToClonedDirectory(dirName)) {
          await _runFlutterPubGet();
          await _changePackageName(
              appInfo['packageName'] ?? "com.example.thunder_cli");
          await _changeAppName(appInfo['appName'] ?? "");

          print('⚡ Init app successfully\n\n');
        } else {
          print('😅 Cloned directory does not exist.');
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

    return {
      'appName': appName,
      'packageName': packageName,
    };
  }

  Future<int> _cloneRepository(String repoUrl, String dirName) async {
    final cloneProcess = await Process.run('git', ['clone', repoUrl, dirName]);
    print(
        "⚡⚡ Cloning repository completed with exit code ${cloneProcess.exitCode}\n\n");
    return cloneProcess.exitCode;
  }

  Future<bool> _navigateToClonedDirectory(String dirName) async {
    final clonedDirectory = Directory(dirName);
    if (clonedDirectory.existsSync()) {
      Directory.current = clonedDirectory;
      print("⚡⚡ Navigated to cloned directory\n\n");
      return true;
    }
    return false;
  }

  Future<void> _runFlutterPubGet() async {
    print("Start initializing your app. Please wait for seconds 🔃");
    final pubGetProcess = await Process.run('flutter', ['pub', 'get'],
        runInShell: true, workingDirectory: Directory.current.path);

    if (pubGetProcess.exitCode == 0) {
      print('⚡ Flutter pub get completed successfully.');
    } else {
      print('😅 Failed to run "flutter pub get". You can run it manually');
    }

    print("⚡⚡ Pub get completed with exit code ${pubGetProcess.exitCode}\n\n");
  }

  Future<void> _changePackageName(String packageName) async {
    await Process.run(
        'flutter', ['pub', 'run', 'change_app_package_name:main', packageName],
        runInShell: true, workingDirectory: Directory.current.path);
    print("⚡⚡ Change package name completed successfully\n\n");
  }

  Future<void> _changeAppName(String appName) async {
    await Process.run(
        'flutter', ['pub', 'run', 'rename_app:main', 'all="$appName"'],
        runInShell: true, workingDirectory: Directory.current.path);
    print("⚡⚡ Change app name completed successfully\n\n");
  }
}
