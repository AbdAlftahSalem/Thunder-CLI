import 'dart:io';

import '../consts/folder_paths.dart';

class LocalData {
  // create singleton for ConstStrings
  static final LocalData instance = LocalData._internal();

  factory LocalData() => instance;

  LocalData._internal();

  Map<String, dynamic> getAppInfo() {
    final file = File(FolderPaths.instance.jsonFile);
    Map<String, dynamic> info = file.readAsStringSync() as Map<String, dynamic>;

    return info;
  }

  String getAppName() {
    return getAppInfo()["appName"];
  }

  String getAppPackageName() {
    return getAppInfo()["packageName"];
  }

  String getAppStateManagement() {
    return getAppInfo()["stateManagement"];
  }
}
