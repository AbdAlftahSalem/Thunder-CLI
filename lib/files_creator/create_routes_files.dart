import 'dart:io';

import '../consts/folder_paths.dart';

class RoutesCreator {
  String nameFolder;

  RoutesCreator({required this.nameFolder});

  void addInRoutesFile() {
    // reading routes file
    final routesFile = File(FolderPaths.instance.routesFile);

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

    print("⚡ Add routes to routes.dart file\n\n");
  }
}
