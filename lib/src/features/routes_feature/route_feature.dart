import '../../core/consts/folder_paths.dart';
import '../../core/consts/state_management.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/services/code_editor/code_editor.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';
import '../../core/services/project_service/project_service.dart';

/// Adds a feature to `routes.dart` (route name) and to `app_routes.dart`
/// (GetX `GetPage`) or `app_router.dart` (go_router `GoRoute`).
class RouteFeature {
  static final _paths = FolderPaths.instance;

  /// Setup route file and add the route of [featureName].
  static Future<void> setRoutes(
      ProjectService project, String featureName) async {
    await addInRouteFile(project, featureName);
    if (project.stateManagement == StateManagement.getx) {
      await addRouteInAppRoute(project, featureName);
    } else {
      await addGoRoute(project, featureName);
    }
  }

  /// The route files changed by [setRoutes].
  static List<String> files(ProjectService project) => [
        _paths.routesFile,
        project.stateManagement == StateManagement.getx
            ? _paths.appRoutesFile
            : _paths.appRouterFile,
      ];

  /// `static const PROFILE = '/profile';`
  static Future<void> addInRouteFile(
      ProjectService project, String featureName) async {
    final file = project.path(_paths.routesFile);
    var content = await FolderAndFileService.readFile(file);
    if (content.isEmpty) {
      content = '''
// ignore_for_file: constant_identifier_names

abstract class Routes {
  // thunder:routes
}
''';
    }
    final constant = featureName.toConstantCase();
    content = CodeEditor.insertAtMarker(
      content,
      marker: 'routes',
      line: "static const $constant = '/${featureName.toSnakeCase()}';",
      alreadyThere: 'static const $constant ',
      indent: '  ',
    );
    await FolderAndFileService.createFile(file, content);
  }

  /// `GetPage(name: Routes.PROFILE, page: () => const ProfileView()),`
  static Future<void> addRouteInAppRoute(
      ProjectService project, String featureName) async {
    final file = project.path(_paths.appRoutesFile);
    var content = await FolderAndFileService.readFile(file);
    if (content.isEmpty) {
      content = '''
import 'package:get/get.dart';

// thunder:imports
import 'routes.dart';

class AppPages {
  static final routes = [
    // thunder:pages
  ];
}
''';
    }
    final constant = featureName.toConstantCase();
    content = CodeEditor.addImport(content,
        project.importOf(_paths.libRelative(_paths.viewFile(featureName))));
    content = CodeEditor.insertAtMarker(
      content,
      marker: 'pages',
      line:
          'GetPage(name: Routes.$constant, page: () => const ${featureName.toDartClassName()}View()),',
      alreadyThere: 'Routes.$constant,',
      fallbackClosing: '];',
    );
    await FolderAndFileService.createFile(file, content);
  }

  /// `GoRoute(path: Routes.PROFILE, builder: (context, state) => const ProfileView()),`
  static Future<void> addGoRoute(
      ProjectService project, String featureName) async {
    final file = project.path(_paths.appRouterFile);
    var content = await FolderAndFileService.readFile(file);
    if (content.isEmpty) {
      content = '''
import 'package:go_router/go_router.dart';

// thunder:imports
import 'routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      // thunder:pages
    ],
  );
}
''';
    }
    final constant = featureName.toConstantCase();
    content = CodeEditor.addImport(content,
        project.importOf(_paths.libRelative(_paths.viewFile(featureName))));
    content = CodeEditor.insertAtMarker(
      content,
      marker: 'pages',
      line:
          'GoRoute(path: Routes.$constant, builder: (context, state) => const ${featureName.toDartClassName()}View()),',
      alreadyThere: 'Routes.$constant,',
      fallbackClosing: '],',
      indent: '      ',
    );
    await FolderAndFileService.createFile(file, content);
  }
}
