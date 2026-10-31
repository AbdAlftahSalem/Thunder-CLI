import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../consts/state_management.dart';

/// Information about the Flutter project Thunder is running in.
class ProjectService {
  /// The project root (the folder that contains `pubspec.yaml`).
  final String root;

  /// The package name from `pubspec.yaml` (used in `package:` imports).
  final String packageName;

  /// `true` when `pubspec.yaml` depends on the Flutter SDK.
  final bool isFlutter;

  ProjectService._(this.root, this.packageName, this.isFlutter);

  /// Finds the closest `pubspec.yaml` from [start] (default: the current
  /// folder) upwards. Returns `null` when Thunder is not inside a project.
  static ProjectService? find([String? start]) {
    var dir = Directory(start ?? Directory.current.path).absolute;
    while (true) {
      final pubspec = File(p.join(dir.path, 'pubspec.yaml'));
      if (pubspec.existsSync()) {
        final content = pubspec.readAsStringSync();
        final name = readPackageName(content);
        if (name != null) {
          return ProjectService._(
              dir.path, name, RegExp(r'sdk:\s*flutter').hasMatch(content));
        }
      }
      final parent = dir.parent;
      if (parent.path == dir.path) return null;
      dir = parent;
    }
  }

  /// Reads `name:` from the content of a `pubspec.yaml` file.
  static String? readPackageName(String pubspecContent) {
    final match = RegExp(r'^name:\s*([A-Za-z0-9_]+)\s*$', multiLine: true)
        .firstMatch(pubspecContent);
    return match?.group(1);
  }

  /// Like [find], but prints a helpful error and returns `null` when the
  /// command is not run inside a Flutter project created by Thunder.
  static ProjectService? require() {
    final project = find();
    if (project == null) {
      stderr.writeln(
          '😢 No pubspec.yaml found. Run this command inside your Flutter project '
          '(create one with: thunder init).');
      return null;
    }
    if (!project.isFlutter) {
      stderr.writeln(
          '😢 ${project.packageName} (${project.root}) is not a Flutter project. '
          'Run this command inside a Flutter app created with: thunder init');
      return null;
    }
    return project;
  }

  /// State management of the project: from `thunder.json` (written by
  /// `thunder init`), otherwise detected from the project files.
  StateManagement get stateManagement {
    final settings = File(path('thunder.json'));
    if (settings.existsSync()) {
      try {
        final json = jsonDecode(settings.readAsStringSync());
        final saved = StateManagement.tryParse(
            json is Map ? json['state_management']?.toString() : null);
        if (saved != null) return saved;
      } on FormatException {
        // fall back to detection
      }
    }
    if (File(path('lib/core/di/injection.dart')).existsSync() ||
        File(path('lib/core/routing/app_router.dart')).existsSync()) {
      final features = Directory(path('lib/app/features'));
      final hasCubit = features.existsSync() &&
          features
              .listSync(recursive: true)
              .any((e) => e is Directory && p.basename(e.path) == 'cubit');
      return hasCubit ? StateManagement.cubit : StateManagement.bloc;
    }
    return StateManagement.getx;
  }

  /// Absolute path of a file inside the project.
  String path(String relative) => p.join(root, relative);

  /// `package:` import for a file under `lib/`.
  /// Ex : `app/models/user_model.dart` => `package:my_app/app/models/user_model.dart`
  String importOf(String libRelativePath) =>
      "import 'package:$packageName/$libRelativePath';";
}
