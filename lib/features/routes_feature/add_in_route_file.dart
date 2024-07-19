import 'dart:io';

import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/folder_and_file_service.dart';

class AddInRouteFile {
  String nameFolder;

  AddInRouteFile({required this.nameFolder});

  void addInRouteFile() async {
    // reading routes file
    String contentFile =
        await FolderAndFileService.readFile(FolderPaths.instance.routesFile);

    final routesMatch = RegExp(r'static const.*?;')
        .allMatches(contentFile)
        .map((e) => e.group(0))
        .toList();

    // if routesMatch is null, then add routes
    contentFile += addNewRouteInAppRouterClass(routesMatch);

    // write content to routes.dart file
    final routesFile = File(FolderPaths.instance.routesFile);
    routesFile.writeAsStringSync(contentFile);

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
