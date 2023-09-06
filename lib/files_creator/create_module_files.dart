import 'dart:io';

import '../consts/const.dart';
import '../extensions/string_extensions.dart';
import '../services/create_folder_files.dart';
import 'create_models.dart';
import 'create_routes_files.dart';

class CreateModuleFiles {
  bool withModel;

  CreateModuleFiles({this.withModel = false});

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
    // set up modules folder
    _setupFoldersModule(name);

    // set up files module
    _setupFilesModule(name);

    // reading routes file
    RoutesCreator(nameFolder: name).addInRoutesFile();

    // Create routes for module
    RoutesCreator(nameFolder: name).addInAppRoutesFile();

    if (withModel) {
      CreateModels().createModelFile();
    }

    print("Create module files successfully 🚀🚀");
  }

  void _setupFoldersModule(String name) {
    // create modules folder
    CreateFolderAndFiles()
        .createFolder('lib/app/modules');

    // create home folder
    CreateFolderAndFiles().createFolder(
        'lib/app/modules/${name.toLowerCase()}');

    // create binding folder
    CreateFolderAndFiles().createFolder(
        'lib/app/modules/${name.toLowerCase()}/binding');

    // controller folder
    CreateFolderAndFiles().createFolder(
        'lib/app/modules/${name.toLowerCase()}/controller');

    // create view folder
    CreateFolderAndFiles().createFolder(
        'lib/app/modules/${name.toLowerCase()}/view');

    // create model folder
    if (withModel) {
      CreateFolderAndFiles().createFolder(
          'lib/app/modules/${name.toLowerCase()}/model');
    }
  }

  void _setupFilesModule(String name) {
    // create home binding file
    CreateFolderAndFiles().createFile(
      'lib/app/modules/${name.toLowerCase()}/binding/${name.toLowerCase()}_binding.dart',
      ConstStrings.instance.binding(name),
    );

    // create home controller file
    CreateFolderAndFiles().createFile(
      'lib/app/modules/${name.toLowerCase()}/controller/${name.toLowerCase()}_controller.dart',
      ConstStrings.instance.controller(name.toCamelCase()),
    );

    // create home view file
    CreateFolderAndFiles().createFile(
      'lib/app/modules/${name.toLowerCase()}/view/${name.toLowerCase()}_view.dart',
      ConstStrings.instance.view(name),
    );
  }
}
