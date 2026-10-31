import 'dart:io';

import 'package:args/args.dart';

import '../../core/extensions/string_extensions.dart';
import '../../core/services/console_service/console.dart';
import 'models/app_data_model.dart';

/// Reads the project data from the command line, asking for anything that
/// was not passed as an option.
class GetProjectData {
  /// Validates a Dart package name (`my_app`). Returns an error or `null`.
  static String? validateAppName(String name) {
    if (name.isEmpty) return 'Application name cannot be empty';
    if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name)) {
      return '"$name" is not a valid package name: use lower case letters, numbers and _ (ex: my_app)';
    }
    if (dartReservedWords.contains(name)) return '"$name" is a Dart keyword';
    return null;
  }

  /// Validates an organization (`com.example`). Returns an error or `null`.
  static String? validateOrganization(String org) {
    if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*(\.[a-zA-Z][a-zA-Z0-9_]*)+$')
        .hasMatch(org)) {
      return '"$org" is not valid: use reverse domain notation (ex: com.example)';
    }
    return null;
  }

  /// Builds the [AppDataModel] from [args] (the `init` command results).
  static AppDataModel getProjectData(ArgResults args) {
    final appDataModel = AppDataModel();

    final rest = args.rest;
    final nameArg =
        (args['name'] as String?) ?? (rest.isNotEmpty ? rest.first : null);
    appDataModel.appName = Console.askValid(
      'Enter your application name (ex: my_app)',
      defaultValue: nameArg?.toSnakeCase() ?? '',
      validate: validateAppName,
    );

    var org = (args['org'] as String?) ?? '';
    if (org.isEmpty) {
      org = Console.askValid('Enter your organization',
          defaultValue: 'com.example', validate: validateOrganization);
    }
    final orgError = validateOrganization(org);
    if (orgError != null) throw ArgumentError(orgError);
    // Accept a full application id (com.company.my_app) as organization too.
    if (org.endsWith('.${appDataModel.appName}')) {
      org = org.substring(0, org.length - appDataModel.appName.length - 1);
    }
    appDataModel.organization = org;

    appDataModel.title = (args['title'] as String?) ??
        appDataModel.appName.words
            .map((w) => w.substring(0, 1).toUpperCase() + w.substring(1))
            .join(' ');
    appDataModel.directory = (args['path'] as String?) ?? appDataModel.appName;
    appDataModel.platforms = (args['platforms'] as List<String>?) ?? const [];

    appDataModel.usingGitHubAction = args.wasParsed('github-action')
        ? args['github-action'] as bool
        : Console.confirm(
            'Add a GitHub Action that builds an APK and sends it to Telegram?');
    appDataModel.initGit = args.wasParsed('git')
        ? args['git'] as bool
        : Console.confirm('Create a git repository with a first commit?',
            defaultValue: true);
    appDataModel.remoteUrl = (args['remote'] as String?) ?? '';
    if (appDataModel.initGit &&
        appDataModel.remoteUrl.isEmpty &&
        !args.wasParsed('git')) {
      appDataModel.remoteUrl =
          Console.ask('GitHub repository URL to push to (leave empty to skip)');
    }
    appDataModel.openInVSCode = args.wasParsed('vscode')
        ? args['vscode'] as bool
        : Console.confirm('Open the project in VS Code?');

    if (Directory(appDataModel.directory).existsSync() &&
        Directory(appDataModel.directory).listSync().isNotEmpty) {
      throw ArgumentError(
          'Folder "${appDataModel.directory}" already exists and is not empty');
    }
    return appDataModel;
  }
}
