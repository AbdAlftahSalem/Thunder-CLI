import 'dart:io';

import '../consts/const.dart';
import '../consts/folder_paths.dart';
import '../extensions/string_extensions.dart';
import '../services/create_folder_files.dart';
import 'create_models.dart';
import 'create_routes_files.dart';

class CreateModuleFiles {
  bool withModel;

  CreateModuleFiles({this.withModel = false});

  void createFiles({bool createDefault = false}) {
    if (createDefault) {
      _generateFiles("login");
      return;
    }
    stdout.write("Enter your view name ( login , bottom_van ) : ");
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

    print("⚡ Create module files successfully\n\n");
  }

  void _setupFoldersModule(String name) {
    // create modules folder
    CreateFolderAndFiles().createFolder(FolderPaths.modulesFolder);

    // create feature folder
    CreateFolderAndFiles().createFolder(FolderPaths.folderInModules(name));

    if (withModel) {
      CreateFolderAndFiles().createFolder(FolderPaths.modelFile(name));
    }
  }

  void _setupFilesModule(String name) {
    // create binding file
    CreateFolderAndFiles().createFile(
      FolderPaths.bindingFile(name),
      ConstStrings.instance.binding(name),
    );

    // create controller file
    CreateFolderAndFiles().createFile(
      FolderPaths.controllerFile(name),
      ConstStrings.instance.controller(name.toCamelCase()),
    );

    // create view file
    CreateFolderAndFiles().createFile(
      FolderPaths.viewFile(name),
      ConstStrings.instance.view(name),
    );
  }
}
