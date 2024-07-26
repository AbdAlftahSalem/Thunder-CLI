import 'dart:io';

import 'package:thunder_cli/core/helper/extensions/string_extensions.dart';

import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/folder_and_file_service.dart';

class AddInAppRouter {
  String nameFolder;

  AddInAppRouter({required this.nameFolder});

  void addRouteInAppRoute() async {
    // reading app_routes.dart file
    String contentFile =
        await FolderAndFileService.readFile(FolderPaths.instance.appRoutesFile);

    // extract all imports from code
    final imports = _getPreviousImports(contentFile);

    // extract routes from code
    final routesMatch = RegExp(r'static final routes = \[([\s\S]*?)\];')
        .firstMatch(contentFile);

    contentFile = _updateImportsInContentFile(imports);

    // if routesMatch is null, then add routes
    contentFile += _updateCodeInContentFile(routesMatch);

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

  String _updateImportsInContentFile(List<String?> imports) {
    if (imports.isEmpty) {
      return '''
import 'package:get/get.dart';
import 'routes.dart';

import '../../features/${nameFolder.toLowerCase()}/ui/${nameFolder.toLowerCase()}_view.dart';

''';
    } else {
      return '''
    ${imports.join('\n')}
import '../../features/${nameFolder.toLowerCase()}/${nameFolder.toLowerCase()}_view.dart';
import 'routes.dart';

''';
    }
  }

  String _updateCodeInContentFile(RegExpMatch? routesMatch) {
    if (routesMatch == null) {
      return '''
class AppPages {
  static final routes = [
    GetPage(
      name: Routes.${nameFolder.toUpperCase()},
      page: () => const ${nameFolder.toCamelCaseFirstLetterForEachWord()}View(),
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
      name: Routes.${nameFolder.toUpperCase()},
      page: () => const ${nameFolder.toCamelCaseFirstLetterForEachWord()}View(),
    ),
   ];
}
''';
    }
  }
}
