import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';

import '../../core/consts/folder_paths.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';


class AddInAppRouter {
  Future<void> addRouteInAppRoute(String featureName) async {
    // reading app_routes.dart file
    String contentFile =
        await FolderAndFileService.readFile(FolderPaths.instance.appRoutesFile);

    // extract all imports from code
    final imports = _getPreviousImports(contentFile);

    // extract routes from code
    final routesMatch = RegExp(r'static final routes = \[([\s\S]*?)\];')
        .firstMatch(contentFile);

    contentFile = _updateImportsInContentFile(imports, featureName);

    // if routesMatch is null, then add routes
    contentFile += _updateCodeInContentFile(routesMatch, featureName);

    // write contentFile to app_routes.dart file
    final file = File(FolderPaths.instance.appRoutesFile);
    file.writeAsStringSync(contentFile);

    print("⚡ Add routes to app_routes.dart file successfully 🎉 ...\n\n");
  }

  List<String?> _getPreviousImports(String contentFile) {
    return RegExp(r'import.*?;')
        .allMatches(contentFile)
        .map((e) => e.group(0))
        .toList();
  }

  String _updateImportsInContentFile(
      List<String?> imports, String featureName) {
    if (imports.isEmpty) {
      return '''
import 'package:get/get.dart';
import 'routes.dart';

import '../../features/${featureName.toLowerCase()}/ui/${featureName.toLowerCase()}_view.dart';

''';
    } else {
      return '''
    ${imports.join('\n')}
import '../../features/${featureName.toLowerCase()}/${featureName.toLowerCase()}_view.dart';
import 'routes.dart';

''';
    }
  }

  String _updateCodeInContentFile(
      RegExpMatch? routesMatch, String featureName) {
    if (routesMatch == null) {
      return '''
class AppPages {
  static final routes = [
    GetPage(
      name: Routes.${featureName.toUpperCase()},
      page: () => const ${featureName.toCamelCaseFirstLetterForEachWord()}View(),
    ),
  ];
}
''';
    } else {
// extract routes from routesMatch
      final routes = routesMatch.group(1);

// add routes to contentFile
      return '''
class AppPages {
  static final routes = [
    $routes
    GetPage(
      name: Routes.${featureName.toUpperCase()},
      page: () => const ${featureName.toCamelCaseFirstLetterForEachWord()}View(),
    ),
   ];
}
''';
    }
  }
}
