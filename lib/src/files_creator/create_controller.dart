import 'dart:io';

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

  void _generateController(String username) {
    final controllerCode = '''
import 'package:get/get.dart';

class ${username}Controller {

  // Add your controller logic here
  
  @override
  void onInit() {
    super.onInit();
  }
}
    ''';

    final fileName = '${username.toLowerCase()}_controller.dart';
    CreateFolderAndFiles().createFile(fileName, controllerCode);

    print("Controller '$fileName' created successfully 🚀🚀");
  }
}
