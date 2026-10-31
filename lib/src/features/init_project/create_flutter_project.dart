import 'dart:io';

import 'package:path/path.dart' as p;

import '../../core/consts/project_template.dart';
import '../../core/services/cmd_service/run_in_cmd.dart';
import '../../core/services/console_service/console.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';
import '../../core/services/project_service/project_service.dart';
import '../create_feature/create_feature.dart';
import 'models/app_data_model.dart';

/// Creates the Flutter project with `flutter create`, adds the packages and
/// writes the Thunder architecture (GetX + MVC) on top of it.
class CreateFlutterProject {
  /// Packages added to every project.
  static const List<String> dependencies = ['get', 'dio'];

  /// Runs every step. Returns `false` when a step failed.
  static Future<bool> create(AppDataModel appInfo) async {
    if (!await RunInCmd.isAvailable('flutter')) {
      Console.error(
          'Flutter was not found in your PATH. Install it from https://docs.flutter.dev/get-started/install');
      return false;
    }

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

    Console.step('Adding packages: ${dependencies.join(', ')} ...');
    final added = await RunInCmd.run('flutter', ['pub', 'add', ...dependencies],
        workingDirectory: root);
    if (added.exitCode != 0) {
      Console.error(
          'Could not add packages. Run "flutter pub add ${dependencies.join(' ')}" yourself.');
      return false;
    }

    Console.step('Writing project structure ...');
    final files = ProjectTemplate.files(
        packageName: appInfo.appName, title: appInfo.title);
    for (final entry in files.entries) {
      await FolderAndFileService.createFile(
          p.join(root, entry.key), entry.value);
    }

    final project = ProjectService.find(root)!;
    await CreateFeatureFiles.generate(project, 'home',
        force: true, quiet: true);

    await RunInCmd.run('dart', ['format', 'lib', 'test'],
        workingDirectory: root, showErrors: false);
    Console.success('Project structure is ready');
    return true;
  }
}
