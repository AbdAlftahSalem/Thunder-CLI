import 'dart:io';

import '../consts/folder_paths.dart';
import '../extensions/string_extensions.dart';

class RoutesCreator {
  String nameFolder;

  RoutesCreator({required this.nameFolder});

  void addInAppRoutesFile() {
    // reading app_routes.dart file
    final file = File(FolderPaths.appRoutesFile);
    String content = file.readAsStringSync();

    // extract all imports from code
    final imports = RegExp(r'import.*?;')
        .allMatches(content)
        .map((e) => e.group(0))
        .toList();

    // extract routes from code
    final routesMatch =
        RegExp(r'static final routes = \[([\s\S]*?)\];').firstMatch(content);

    // if import length is 0, then add import
    if (imports.isEmpty) {
      content = '''
import '/app/routes/routes.dart';
import 'package:get/get.dart';
import '../modules/${nameFolder.toLowerCase()}/binding/${nameFolder.toLowerCase()}_binding.dart';
import '../modules/${nameFolder.toLowerCase()}/view/${nameFolder.toLowerCase()}_view.dart';

''';
    } else {
      content = '''
    ${imports.join('\n')}
import '../modules/${nameFolder.toLowerCase()}/binding/${nameFolder.toLowerCase()}_binding.dart';
import '../modules/${nameFolder.toLowerCase()}/view/${nameFolder.toLowerCase()}_view.dart';
''';
    }

    // if routesMatch is null, then add routes
    if (routesMatch == null) {
      content += '''
class AppPages {
  static final routes = [
    GetPage(
      name: Routes.${nameFolder.toUpperCase()},
      page: () => ${nameFolder.toCamelCase()}View(),
      binding: ${nameFolder.toCamelCase()}Binding(),
    ),
  ];
}
''';
    } else {
// extract routes from routesMatch
      final routes = routesMatch.group(1);

// add routes to content
      content += '''
class AppPages {
  static final routes = [
    $routes
    GetPage(
      name: Routes.${nameFolder.toUpperCase()},
      page: () => ${nameFolder.toCamelCase()}View(),
      binding: ${nameFolder.toCamelCase()}Binding(),
    ),
    ];
}
''';
    }

    // write content to app_routes.dart file
    file.writeAsStringSync(content);
  }

  void addInRoutesFile() {
    // reading routes file
    final routesFile = File(FolderPaths.routesFile);

    // reading routes file content
    String routesContent = routesFile.readAsStringSync();

    final routesMatch = RegExp(r'static const.*?;')
        .allMatches(routesContent)
        .map((e) => e.group(0))
        .toList();

    // if routesMatch is null, then add routes
    if (routesMatch.isEmpty) {
      // add routes to content
      routesContent += '''
class Routes {
  static const ${nameFolder.toUpperCase()} = '/${nameFolder.toLowerCase()}';
}
''';
    } else {
      routesMatch.add(
          '  static const ${nameFolder.toUpperCase()} = "/${nameFolder.toLowerCase()}";');
      String routes = routesMatch.join('\n');
      routesContent = '''
class Routes {
  $routes
}
''';
    }

    // write content to routes.dart file
    routesFile.writeAsStringSync(routesContent);
  }
}
