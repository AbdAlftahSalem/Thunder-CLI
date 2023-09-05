import 'dart:io';

import '../consts/const.dart';
import '../services/create_folder_files.dart';

class CreateView {
  void createView() {
    print("Welcome to the Thunder Creator!");
    stdout.write("Enter your view name [ login / bottom_nav ] : ");
    final username = stdin.readLineSync();

    if (username == null || username.isEmpty) {
      print("Controller name cannot be empty !!");
    } else {
      _generateController(username);
    }
  }

  void _generateController(String viewName) {
    CreateFolderAndFiles().createFolder('lib/app/modules/$viewName');
    final fileName =
        'lib/app/modules/$viewName/${viewName.toLowerCase()}_view.dart';
    CreateFolderAndFiles().createFile(
      fileName,
      ConstStrings.instance.view(viewName),
    );

    print("View '$fileName' created successfully 🚀🚀");
  }
}
