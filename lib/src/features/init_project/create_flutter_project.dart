import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../core/consts/folder_paths.dart';
import '../../core/services/cmd_service/run_in_cmd.dart';
import '../../core/services/console_service/console.dart';
import '../../core/services/project_service/project_service.dart';
import 'models/app_data_model.dart';
import 'template_source.dart';

/// Creates the Flutter project: `flutter create` for the platform folders
/// (with the right application id), then the template's `lib/`, `test/`,
/// `assets/`, `pubspec.yaml` and `analysis_options.yaml` on top of it.
class CreateFlutterProject {
  /// What is copied from the template.
  static const List<String> templateEntries = [
    'lib',
    'test',
    'assets',
    'pubspec.yaml',
    'analysis_options.yaml',
  ];

  /// Runs every step. Returns `false` when a step failed.
  static Future<bool> create(AppDataModel appInfo) async {
    if (!await RunInCmd.isAvailable('flutter')) {
      Console.error(
          'Flutter was not found in your PATH. Install it from https://docs.flutter.dev/get-started/install');
      return false;
    }

    final workDir = await Directory.systemTemp.createTemp('thunder_');
    try {
      final Directory template;
      try {
        template = await TemplateSource.fetch(
          state: appInfo.stateManagement,
          template: appInfo.template,
          offline: appInfo.offline,
          workDir: workDir,
        );
      } catch (e) {
        Console.error(
            'Could not get the template: ${e.toString().replaceFirst('Exception: ', '')}');
        return false;
      }
      final templatePubspec = File(p.join(template.path, 'pubspec.yaml'));
      final templateName = ProjectService.readPackageName(
              templatePubspec.existsSync()
                  ? templatePubspec.readAsStringSync()
                  : '') ??
          'thunder_template';

      Console.step(
          'Creating Flutter project "${appInfo.appName}" (${appInfo.packageName}) ...');
      final created = await RunInCmd.run('flutter', [
        'create',
        '--org',
        appInfo.organization,
        '--project-name',
        appInfo.appName,
        if (appInfo.platforms.isNotEmpty)
          '--platforms=${appInfo.platforms.join(',')}',
        '--no-pub',
        appInfo.directory,
      ]);
      if (created.exitCode != 0) {
        Console.error('flutter create failed.');
        return false;
      }
      final root = Directory(appInfo.directory).absolute.path;

      Console.step(
          'Applying the ${appInfo.stateManagement.label} template ...');
      await applyTemplate(
        template: template.path,
        root: root,
        templateName: templateName,
        appName: appInfo.appName,
        title: appInfo.title,
      );
      await writeSettings(root, appInfo);

      Console.step('Getting packages ...');
      final pubGet =
          await RunInCmd.run('flutter', ['pub', 'get'], workingDirectory: root);
      if (pubGet.exitCode != 0) {
        Console.error(
            'flutter pub get failed. Fix the error above, then run it again.');
        return false;
      }
      await RunInCmd.run('dart', ['format', 'lib', 'test'],
          workingDirectory: root, showErrors: false);
      Console.success('Project is ready');
      return true;
    } finally {
      try {
        workDir.deleteSync(recursive: true);
      } catch (_) {}
    }
  }

  /// Copies the template into [root] and renames `package:<templateName>/`
  /// imports and the template title.
  static Future<void> applyTemplate({
    required String template,
    required String root,
    required String templateName,
    required String appName,
    required String title,
  }) async {
    for (final folder in ['lib', 'test']) {
      final dir = Directory(p.join(root, folder));
      if (dir.existsSync() &&
          Directory(p.join(template, folder)).existsSync()) {
        dir.deleteSync(recursive: true);
      }
    }
    for (final entry in templateEntries) {
      final source = p.join(template, entry);
      if (File(source).existsSync()) {
        await _copyFile(File(source), File(p.join(root, entry)), templateName,
            appName, title);
      } else if (Directory(source).existsSync()) {
        for (final file
            in Directory(source).listSync(recursive: true).whereType<File>()) {
          final relative = p.relative(file.path, from: template);
          await _copyFile(
              file, File(p.join(root, relative)), templateName, appName, title);
        }
      }
    }
  }

  static Future<void> _copyFile(File source, File target, String templateName,
      String appName, String title) async {
    await target.parent.create(recursive: true);
    final name = p.basename(source.path);
    if (name.endsWith('.dart')) {
      final content = (await source.readAsString())
          .replaceAll('package:$templateName/', 'package:$appName/')
          .replaceAll('Thunder Template',
              title.replaceAll("'", '').replaceAll('"', ''));
      await target.writeAsString(content);
    } else if (name == 'pubspec.yaml') {
      final content = (await source.readAsString())
          .replaceFirst(RegExp(r'^name:.*$', multiLine: true), 'name: $appName')
          .replaceFirst(RegExp(r'^description:.*$', multiLine: true),
              'description: ${jsonEncode('$title — created with Thunder CLI.')}');
      await target.writeAsString(content);
    } else {
      await source.copy(target.path);
    }
  }

  /// Saves the project settings in `thunder.json`.
  static Future<void> writeSettings(String root, AppDataModel appInfo) async {
    final file = File(p.join(root, FolderPaths.instance.thunderJsonFile));
    final settings = {
      'state_management': appInfo.stateManagement.name,
      'template': appInfo.offline
          ? 'bundled'
          : (appInfo.template ??
              '${TemplateSource.defaultRepository}#${appInfo.stateManagement.name}'),
    };
    await file.writeAsString(
        '${const JsonEncoder.withIndent('  ').convert(settings)}\n');
  }
}
