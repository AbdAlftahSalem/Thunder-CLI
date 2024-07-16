import 'dart:io';

import '../consts/const_strings.dart';
import '../consts/folder_paths.dart';
import '../extensions/string_extensions.dart';
import '../features/routes_feature/route_feature.dart';
import '../services/create_folder_files.dart';
import 'create_api_model.dart';

class CreateFeatureFiles {
  bool withModel;

  CreateFeatureFiles({this.withModel = false});

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

  _generateFiles(String fileName) {
    // set up modules folder
    _setupFoldersModule(fileName);

    // set up files module
    _setupFilesModule(fileName);

    try {
      // reading routes file
      RouteFeature(nameFolder: fileName);
    } catch (e) {
      print('😢 Error in create routes . \n $e');
    }

    if (withModel) {
      CreateApiModel().createModelFile();
    }

    print("⚡ Create module files successfully\n\n");
  }

  void _setupFoldersModule(String name) {
    // create modules folder
    CreateFolderAndFiles().createFolder(FolderPaths.instance.modulesFolder);

    // create feature folder
    CreateFolderAndFiles()
        .createFolder(FolderPaths.instance.folderInModules(name));

    if (withModel) {
      CreateFolderAndFiles().createFolder(FolderPaths.instance.modelFile(name));
    }
  }

  void _setupFilesModule(String name) {
    // // create binding file
    // CreateFolderAndFiles().createFile(
    //   FolderPaths.instancebindingFile(name),
    //   ConstStrings.instance.bindingGetX(name),
    // );

    try {
      // create controller file
      CreateFolderAndFiles().createFile(
        FolderPaths.instance.controllerFile(name),
        ConstStrings.instance.controllerGetX(name.toCamelCaseFirstLetter()),
      );

      // create view file
      CreateFolderAndFiles().createFile(
        FolderPaths.instance.viewFile(name),
        ConstStrings.instance.viewGetX(name),
      );
    } catch (e) {
      print('😢 Error in create view or controller . \n $e');
    }
  }
}
