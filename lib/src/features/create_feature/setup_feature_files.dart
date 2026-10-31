import '../../core/consts/const_strings.dart';
import '../../core/consts/folder_paths.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/services/code_editor/code_editor.dart';
import '../../core/services/console_service/console.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';
import '../../core/services/format_service/format_service.dart';
import '../../core/services/project_service/project_service.dart';

/// Writes the view, controller and repository of a feature and registers
/// them for dependency injection.
class SetupFeatureFiles {
  static final _paths = FolderPaths.instance;

  /// Creates the feature files. Existing files are kept unless [force].
  static Future<List<String>> setupFeatureFiles(
    ProjectService project,
    String featureName, {
    bool force = false,
    bool quiet = false,
  }) async {
    final written = <String>[];
    final files = {
      _paths.controllerFile(featureName): ConstStrings.instance
          .controllerGetX(featureName, packageName: project.packageName),
      _paths.viewFile(featureName): ConstStrings.instance
          .viewGetX(featureName, packageName: project.packageName),
      _paths.repoFile(featureName): ConstStrings.instance
          .repo(featureName, packageName: project.packageName),
    };

    for (final entry in files.entries) {
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
    await FormatService.format(project, [...written, _paths.bindingsFile]);
    return written;
  }

  /// Registers `<Feature>Repo` and `<Feature>Controller` in `bindings_app.dart`.
  static Future<void> bindings(
    ProjectService project,
    String featureName, {
    bool withController = true,
    bool quiet = false,
  }) async {
    final className = featureName.toDartClassName();
    final snake = featureName.toSnakeCase();
    final file = project.path(_paths.bindingsFile);
    var content = await FolderAndFileService.readFile(file);
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
          'Get.lazyPut(() => ${className}Repo(Get.find<DioHelper>()), fenix: true);',
      alreadyThere: '${className}Repo(Get.find',
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
            'Get.lazyPut(() => ${className}Controller(${'${className}Repo'.lowerCaseFirstLetter()}: Get.find<${className}Repo>()), fenix: true);',
        alreadyThere: '${className}Controller(',
        fallbackAfter: 'void dependencies() {',
      );
    }
    await FolderAndFileService.createFile(file, content);
    if (!quiet) Console.success("Register '$snake' in bindings_app.dart");
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
