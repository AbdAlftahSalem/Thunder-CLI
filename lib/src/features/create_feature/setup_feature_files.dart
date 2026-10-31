import '../../core/consts/bloc_strings.dart';
import '../../core/consts/const_strings.dart';
import '../../core/consts/folder_paths.dart';
import '../../core/consts/state_management.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/services/code_editor/code_editor.dart';
import '../../core/services/console_service/console.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';
import '../../core/services/format_service/format_service.dart';
import '../../core/services/project_service/project_service.dart';

/// Writes the files of a feature (GetX, BLoC or Cubit) and registers them
/// for dependency injection.
class SetupFeatureFiles {
  static final _paths = FolderPaths.instance;

  /// Files of [featureName] for the project's state management.
  static Map<String, String> featureFiles(
      ProjectService project, String featureName) {
    final pkg = project.packageName;
    final repo = {
      _paths.repoFile(featureName):
          ConstStrings.instance.repo(featureName, packageName: pkg)
    };
    switch (project.stateManagement) {
      case StateManagement.getx:
        return {
          _paths.controllerFile(featureName): ConstStrings.instance
              .controllerGetX(featureName, packageName: pkg),
          _paths.viewFile(featureName):
              ConstStrings.instance.viewGetX(featureName, packageName: pkg),
          ...repo,
        };
      case StateManagement.bloc:
        return {
          _paths.blocFile(featureName):
              BlocStrings.instance.bloc(featureName, packageName: pkg),
          _paths.eventFile(featureName):
              BlocStrings.instance.event(featureName),
          _paths.stateFile(featureName, cubit: false):
              BlocStrings.instance.state(featureName, cubit: false),
          _paths.viewFile(featureName): BlocStrings.instance
              .view(featureName, packageName: pkg, cubit: false),
          ...repo,
        };
      case StateManagement.cubit:
        return {
          _paths.cubitFile(featureName):
              BlocStrings.instance.cubit(featureName, packageName: pkg),
          _paths.stateFile(featureName, cubit: true):
              BlocStrings.instance.state(featureName, cubit: true),
          _paths.viewFile(featureName): BlocStrings.instance
              .view(featureName, packageName: pkg, cubit: true),
          ...repo,
        };
    }
  }

  /// Creates the feature files. Existing files are kept unless [force].
  static Future<List<String>> setupFeatureFiles(
    ProjectService project,
    String featureName, {
    bool force = false,
    bool quiet = false,
  }) async {
    final written = <String>[];
    for (final entry in featureFiles(project, featureName).entries) {
      final path = project.path(entry.key);
      if (FolderAndFileService.exists(path) && !force) {
        Console.warning(
            '${entry.key} already exists, skipped (use --force to overwrite)');
        continue;
      }
      await FolderAndFileService.createFile(path, entry.value);
      written.add(entry.key);
      if (!quiet) Console.success('Create ${entry.key}');
    }

    await addEndpoint(
        project, featureName.toDartIdentifier(), featureName.toSnakeCase());
    await bindings(project, featureName, quiet: quiet);
    await FormatService.format(project, [...written, _diFile(project)]);
    return written;
  }

  static String _diFile(ProjectService project) =>
      project.stateManagement == StateManagement.getx
          ? _paths.bindingsFile
          : _paths.diFile;

  /// Registers `<Feature>Repo` and its controller / bloc / cubit for
  /// dependency injection (`bindings_app.dart` for GetX, `injection.dart`
  /// for BLoC and Cubit).
  static Future<void> bindings(
    ProjectService project,
    String featureName, {
    bool withController = true,
    bool quiet = false,
  }) async {
    final style = project.stateManagement;
    final className = featureName.toDartClassName();
    final snake = featureName.toSnakeCase();
    final repoClass = '${className}Repo';
    final repoField = repoClass.lowerCaseFirstLetter();
    final file = project.path(_diFile(project));
    var content = await FolderAndFileService.readFile(file);

    if (style == StateManagement.getx) {
      if (content.isEmpty) {
        content = '''
import 'package:get/get.dart';

import '../networking/base_client.dart';
// thunder:imports

class BindingApp extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DioHelper(), fenix: true);
    // thunder:bindings
  }
}
''';
      }
      content = CodeEditor.addImport(content,
          project.importOf(_paths.libRelative(_paths.repoFile(featureName))));
      content = CodeEditor.insertAtMarker(
        content,
        marker: 'bindings',
        line:
            'Get.lazyPut(() => $repoClass(Get.find<DioHelper>()), fenix: true);',
        alreadyThere: '$repoClass(Get.find',
        fallbackAfter: 'void dependencies() {',
      );
      if (withController) {
        content = CodeEditor.addImport(
            content,
            project.importOf(
                _paths.libRelative(_paths.controllerFile(featureName))));
        content = CodeEditor.insertAtMarker(
          content,
          marker: 'bindings',
          line:
              'Get.lazyPut(() => ${className}Controller($repoField: Get.find<$repoClass>()), fenix: true);',
          alreadyThere: '${className}Controller(',
          fallbackAfter: 'void dependencies() {',
        );
      }
    } else {
      final cubit = style == StateManagement.cubit;
      if (content.isEmpty) {
        content = '''
import 'package:get_it/get_it.dart';

import '../networking/base_client.dart';
// thunder:imports

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton(() => DioHelper());
  // thunder:di
}
''';
      }
      content = CodeEditor.addImport(content,
          project.importOf(_paths.libRelative(_paths.repoFile(featureName))));
      content = CodeEditor.insertAtMarker(
        content,
        marker: 'di',
        line: 'sl.registerLazySingleton(() => $repoClass(sl()));',
        alreadyThere: '=> $repoClass(sl',
        fallbackAfter: 'Future<void> setupDependencies() async {',
        indent: '  ',
      );
      if (withController) {
        final kindClass = '$className${cubit ? 'Cubit' : 'Bloc'}';
        content = CodeEditor.addImport(
            content,
            project.importOf(_paths.libRelative(cubit
                ? _paths.cubitFile(featureName)
                : _paths.blocFile(featureName))));
        content = CodeEditor.insertAtMarker(
          content,
          marker: 'di',
          line: 'sl.registerFactory(() => $kindClass($repoField: sl()));',
          alreadyThere: '=> $kindClass(',
          fallbackAfter: 'Future<void> setupDependencies() async {',
          indent: '  ',
        );
      }
    }
    await FolderAndFileService.createFile(file, content);
    if (!quiet) {
      Console.success(
          "Register '$snake' in ${_diFile(project).split('/').last}");
    }
  }

  /// Adds `static const <name> = '<path>';` to `api_constants.dart`.
  static Future<void> addEndpoint(
      ProjectService project, String name, String path) async {
    final file = project.path(_paths.apiConstRoutesFile);
    var content = await FolderAndFileService.readFile(file);
    if (content.isEmpty) {
      content = '''
class ApiConstants {
  static const baseUrl = 'http://localhost:8000/';
  // thunder:endpoints
}
''';
    }
    content = CodeEditor.insertAtMarker(
      content,
      marker: 'endpoints',
      line: "static const $name = '${path.escapeForDartString()}';",
      alreadyThere: 'static const $name ',
      indent: '  ',
    );
    await FolderAndFileService.createFile(file, content);
  }
}
