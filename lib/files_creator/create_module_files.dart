import 'dart:io';

import '../consts/const.dart';
import '../extensions/string_extensions.dart';
import '../services/create_folder_files.dart';

class CreateModuleFiles {
  void createFiles() {
    stdout.write("Enter your view name [ login / bottom_nav ] : ");
    final name = stdin.readLineSync();

    if (name == null || name.isEmpty) {
      print("Name name cannot be empty !!");
    } else {
      _generateFiles(name);
    }
  }

  _generateFiles(String name) {
    // create modules folder
    CreateFolderAndFiles()
        .createFolder('E:/Flutter new/crypto_new/lib/app/modules');

    // create home folder
    CreateFolderAndFiles().createFolder(
        'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}');

    // create binding folder
    CreateFolderAndFiles().createFolder(
        'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/binding');

    // create home binding file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/binding/${name.toLowerCase()}_binding.dart',
      ConstStrings.instance.binding(name),
    );

    // controller folder
    CreateFolderAndFiles().createFolder(
        'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/controller');

    // create home controller file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/controller/${name.toLowerCase()}_controller.dart',
      ConstStrings.instance.controller(name.toCamelCase()),
    );

    // create view folder
    CreateFolderAndFiles().createFolder(
        'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/view');

    // create home view file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/view/${name.toLowerCase()}_view.dart',
      ConstStrings.instance.view(name),
    );

    // reading routes file
    _addInRoutes(name);

    // Aad rout in app_routes.dart file
    _addAppRout(name);

    print("Create module files successfully 🚀🚀");
  }

  void _addInRoutes(String name) {
    // create routes file

    // reading routes file
    final routesFile =
        File('E:/Flutter new/crypto_new/lib/app/routes/routes.dart');

    // reading routes file content
    String routesContent = routesFile.readAsStringSync();

    final routesMatch = RegExp(r'static const.*?;')
        .allMatches(routesContent)
        .map((e) => e.group(0))
        .toList();

    // if routesMatch is null, then add routes
    if (routesMatch.isEmpty) {
      routesContent += '''
class Routes {
  static const ${name.toUpperCase()} = '/${name.toLowerCase()}';
}
''';
    } else {
      // add routes to content

      routesMatch.add(
          '  static const ${name.toUpperCase()} = "/${name.toLowerCase()}";');
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

  void _addAppRout(String name) {
    // reading app_routes.dart file
    final file =
        File('E:/Flutter new/crypto_new/lib/app/routes/app_routes.dart');
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
import '../modules/${name.toLowerCase()}/binding/${name.toLowerCase()}_binding.dart';
import '../modules/${name.toLowerCase()}/view/${name.toLowerCase()}_view.dart';

''';
    } else {
      content = '''
    ${imports.join('\n')}
import '../modules/${name.toLowerCase()}/binding/${name.toLowerCase()}_binding.dart';
import '../modules/${name.toLowerCase()}/view/${name.toLowerCase()}_view.dart';
''';
    }

    // if routesMatch is null, then add routes
    if (routesMatch == null) {
      content += '''
class AppPages {
  static final routes = [
    GetPage(
      name: Routes.${name.toUpperCase()},
      page: () => ${name.toCamelCase()}View(),
      binding: ${name.toCamelCase()}Binding(),
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
      name: Routes.${name.toUpperCase()},
      page: () => ${name.toCamelCase()}View(),
      binding: ${name.toCamelCase()}Binding(),
    ),
    ];
}
''';
    }

    // write content to app_routes.dart file
    file.writeAsStringSync(content);
  }
}
