import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/features/init_project/models/app_data_model.dart';
import 'package:thunder_cli/features/init_project/set_up_github_action.dart';
import 'package:thunder_cli/features/init_project/setup_flavor.dart';

class GetProjectData {
  static AppDataModel getProjectData() {
    AppDataModel appDataModel = AppDataModel();

    setupAppName(appDataModel);

    setupPackageName(appDataModel);

    setupStateManagement(appDataModel);

    setupGithubAction(appDataModel);

    if (appDataModel.usingGitHubAction) SetUpGithubAction.setUpGithubAction();

    setupFlavors(appDataModel);

    if (appDataModel.usingFlavors) SetupFlavor.setupFlavor();

    return appDataModel;
  }

  static void setupFlavors(AppDataModel appDataModel) {
    stdout.write('😎 Do you want to using App flavors ? (y , N)[ default y ] ');
    appDataModel.usingFlavors =
        (stdin.readLineSync()?.trim() ?? "").toLowerCase() == 'n'
            ? false
            : true;
  }

  static void setupGithubAction(AppDataModel appDataModel) {
    stdout
        .write('😎 Do you want to using GitHubActions ? (y , N)[ default y ] ');
    appDataModel.usingGitHubAction =
        (stdin.readLineSync()?.trim() ?? "").toLowerCase() == 'n'
            ? false
            : true;
  }

  static void setupStateManagement(AppDataModel appDataModel) {
    while (appDataModel.stateManagement.isEmpty) {
      stdout.write('😎 Enter your state management [ GetX / BloC ]: ');
      final stateManagement = stdin.readLineSync()?.trim() ?? "";
      if (stateManagement.toLowerCase() == 'getx') {
        appDataModel.stateManagement = "GetX";
      } else if (stateManagement.toLowerCase() == 'bloc') {
        appDataModel.stateManagement = 'BloC';
      }
    }
  }

  static void setupPackageName(AppDataModel appDataModel) {
    while (appDataModel.packageName.isEmpty ||
        (appDataModel.packageName.split(".").length == 1)) {
      stdout.write('😎 Enter your package name: ');
      appDataModel.packageName = (stdin
                  .readLineSync()
                  ?.trim()
                  .replaceAll(" ", "_")
                  .toLowerCase() ??
              "")
          .checkIfEmptyAndNullAndShowMessage("😢 Package name cannot be empty");
    }
  }

  static void setupAppName(AppDataModel appDataModel) {
    while (appDataModel.appName.isEmpty) {
      stdout.write('😎 Enter your application name: ');
      appDataModel.appName =
          (stdin.readLineSync()?.trim().replaceAll(" ", "_").toLowerCase() ??
                  "")
              .checkIfEmptyAndNullAndShowMessage(
                  "😢 Application name cannot be empty");
    }
  }
}
