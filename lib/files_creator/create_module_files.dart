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
    stdout.write("Enter your view name ( login ) : ");
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
    CreateFolderAndFiles().createFolder(FolderPaths.modulesFolder);

    // create home folder
    CreateFolderAndFiles().createFolder(FolderPaths.folderInModules(name));

    // create binding folder
    CreateFolderAndFiles().createFolder(FolderPaths.bindingFolder(name));

    // controller folder
    CreateFolderAndFiles().createFolder(FolderPaths.controllerFolder(name));

    // create view folder
    CreateFolderAndFiles().createFolder(FolderPaths.viewFolder(name));

    // create model folder
    if (withModel) {
      CreateFolderAndFiles().createFolder(FolderPaths.modelFile(name));
    }
  }

  void _setupFilesModule(String name) {
    // create home binding file
    CreateFolderAndFiles().createFile(
      FolderPaths.bindingFile(name),
      ConstStrings.instance.binding(name),
    );

    // create home controller file
    CreateFolderAndFiles().createFile(
      FolderPaths.controllerFile(name),
      ConstStrings.instance.controller(name.toCamelCase()),
    );

    // create home view file
    CreateFolderAndFiles().createFile(
      FolderPaths.viewFile(name),
      ConstStrings.instance.view(name),
    );
  }
}
