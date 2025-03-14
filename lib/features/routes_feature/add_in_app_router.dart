import 'dart:io';

import 'package:thunder_cli/core/consts/folder_paths.dart';
import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';

class AddInAppRouter {
  static Future<void> addRouteInAppRoute(String featureName) async {
    // reading app_routes.dart file
    String contentFile =
        await FolderAndFileService.readFile(FolderPaths.instance.appRoutesFile);

    // extract all imports from code
    List<String?> imports = _getPreviousImports(contentFile);

    // extract routes from code
    final routesMatch = RegExp(r'static final routes = \[([\s\S]*?)\];')
        .firstMatch(contentFile);

    contentFile = _updateImportsInContentFile(imports, featureName);

    // if routesMatch is null, then add routes
    contentFile += _updateCodeInContentFile(routesMatch, featureName);

    // write contentFile to app_routes.dart file
    final file = File(FolderPaths.instance.appRoutesFile);
    file.writeAsStringSync(contentFile);
  }

  static List<String?> _getPreviousImports(String contentFile) {
    List<String?> imports = RegExp(r'import.*?;')
        .allMatches(contentFile)
        .map((e) => e.group(0))
        .toList();

    imports = imports.map((e) => (e ?? "").trim()).toList();

    return imports;
  }

  static String _updateImportsInContentFile(
      List<String?> imports, String featureName) {
    if (imports.isEmpty) {
      return '''
import 'package:get/get.dart';
import 'routes.dart';

import '../../app/ui/${featureName.toLowerCase()}_view.dart';

''';
    } else {
      return '''
    ${imports.join('\n')}
import '../../app/ui/${featureName.toLowerCase()}_view.dart';

''';
    }
  }

  static String _updateCodeInContentFile(
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
