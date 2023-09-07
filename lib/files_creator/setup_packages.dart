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
      'rename_app',
      'flutter_svg',
      'pretty_dio_logger',
    ];

    Future.forEach(packages, (package) async {
      await RunCmd.runInCmd('flutter pub add $package');
      print("Add $package package 🚀🚀");
    });

    // set up app name
    await RunCmd.runInCmd(
        'flutter pub run rename_app:main all="${appInfo['appName']}"');

    // set up package name
    await RunCmd.runInCmd(
        'flutter pub run change_app_package_name:main ${appInfo['packageName']}');
  }
}
