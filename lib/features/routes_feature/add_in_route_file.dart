import 'dart:io';

import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/folder_and_file_service.dart';

class AddInRouteFile {
  /// Add feature route in Route file
  static Future<void> addInRouteFile(String featureName) async {
    // reading routes file
    String contentFile =
        await FolderAndFileService.readFile(FolderPaths.instance.routesFile);

    List<String?> prevRoutes = RegExp(r'static const.*?;')
        .allMatches(contentFile)
        .map((e) => e.group(0))
        .toList();

    prevRoutes.add(
        "static const ${featureName.toUpperCase()} = '/${featureName.toLowerCase()}';");

    contentFile = """
class Routes {
  ${prevRoutes.join("\n")}
}
    """;

    // write content to routes.dart file
    final routesFile = File(FolderPaths.instance.routesFile);
    routesFile.writeAsStringSync(contentFile);

    print("⚡ Add routes to routes.dart file successfully 🎉 ...\n\n");
  }
}
