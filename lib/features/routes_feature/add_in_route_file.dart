import 'dart:io';

import '../../core/helper/consts/folder_paths.dart';

class AddInRouteFile {
  String nameFolder;

  AddInRouteFile({required this.nameFolder});

  void addInRouteFile() {
    // reading routes file
    final routesFile = File(FolderPaths.instance.routesFile);

    // reading routes file content
    String routesContent = routesFile.readAsStringSync();

    final routesMatch = RegExp(r'static const.*?;')
        .allMatches(routesContent)
        .map((e) => e.group(0))
        .toList();

    // if routesMatch is null, then add routes
    routesContent += addNewRouteInAppRouterClass(routesMatch);

    // write content to routes.dart file
    routesFile.writeAsStringSync(routesContent);

    print("⚡ Add routes to routes.dart file successfully 🎉 ...\n\n");
  }

  String addNewRouteInAppRouterClass(List<String?> routesMatch) {
    if (routesMatch.isEmpty) {
      // add routes to content
      return '''
class Routes {
  static const ${nameFolder.toUpperCase()} = '/${nameFolder.toLowerCase()}';
}
''';
    } else {
      routesMatch.add(
          '  static const ${nameFolder.toUpperCase()} = "/${nameFolder.toLowerCase()}";');
      String routes = routesMatch.join('\n');
      return '''
class Routes {
  $routes
}
''';
    }
  }
}
