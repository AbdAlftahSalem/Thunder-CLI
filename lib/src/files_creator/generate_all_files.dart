import 'dart:io';

import '../consts/const.dart';
import '../services/create_folder_files.dart';

class CreateAllFiles {
  void createFiles() {
    print("Welcome to the Thunder Creator!");
    stdout.write("Enter your view name [ login / bottom_nav ] : ");
    final name = stdin.readLineSync();

    if (name == null || name.isEmpty) {
      print("Name name cannot be empty !!");
    } else {
      _generateFiles(name);
    }
  }

  _generateFiles(String name) {
    // Create Folder
    CreateFolderAndFiles().createFolder('app/modules/$name');

    // Create View
    final viewFileName = 'app/modules/$name/${name.toLowerCase()}_view.dart';

    CreateFolderAndFiles().createFile(
      viewFileName,
      ConstStrings.instance.view(name),
    );

    print("View '$viewFileName' created successfully 🚀🚀");

    // Create Controller
    final controllerFileName =
        'app/modules/$name/${name.toLowerCase()}_controller.dart';

    CreateFolderAndFiles().createFile(
      controllerFileName,
      ConstStrings.instance.controller(name),
    );

    print("Controller '$controllerFileName' created successfully 🚀🚀");

    // Create Binding
    final bindingFileName =
        'app/modules/$name/${name.toLowerCase()}_binding.dart';

    CreateFolderAndFiles().createFile(
      bindingFileName,
      ConstStrings.instance.binding(name),
    );

    print("Binding '$bindingFileName' created successfully 🚀🚀");
  }
}
