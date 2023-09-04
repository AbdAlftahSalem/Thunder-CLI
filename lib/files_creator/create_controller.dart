import 'dart:io';

import '../consts/const.dart';
import '../services/create_folder_files.dart';

class CreateController {
  void createController() {
    print("Welcome to the Thunder Creator!");
    stdout.write("Enter your controller name : ");
    final username = stdin.readLineSync();

    if (username == null || username.isEmpty) {
      print("Controller name cannot be empty !!");
    } else {
      _generateController(username);
    }
  }

  void _generateController(String controllerName) {
    final fileName = '${controllerName.toLowerCase()}_controller.dart';
    CreateFolderAndFiles()
        .createFile(fileName, ConstStrings.instance.controller(controllerName));

    print("Controller '$fileName' created successfully 🚀🚀");
  }
}
