import '../services/run_cmd.dart';

class SetupPackagesAndAppInfo {
  Future setupPackagesAndAppInfo(Map<String, String> appInfo) async {
    final packages = [
      'get',
      'logger',
      'flutter_screenutil',
      'dio',
      'hive',
      'hive_flutter',
      'shared_preferences',
      'firebase_core',
      'firebase_messaging',
      'awesome_notifications',
      'flutter_launcher_icons',
      'change_app_package_name',
      'pretty_dio_logger',
    ];

    await Future.forEach(packages, (package) async {
      await RunCmd.runInCmd('flutter pub add $package');
      print("✅ Add $package package");
    });

    await RunCmd.runInCmd('flutter pub get');

    print("⚡ Get packages , thunder install ${packages.length} packages");

    await RunCmd.runInCmd(
        'flutter pub global run rename --appname ${appInfo['appName']} --target android ios windows macOS linux');

    print("⚡ Rename app name to ${appInfo['appName']}");

    // set up package name
    await RunCmd.runInCmd(
        'flutter pub run change_app_package_name:main ${appInfo['packageName']}');

    print("⚡ Change package name to ${appInfo['packageName']}");
  }
}
