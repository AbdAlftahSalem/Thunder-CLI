import 'dart:io';

import '../consts/const.dart';
import '../services/create_folder_files.dart';

class CreateBinding {
  void createBinding() {
    print("Welcome to the Thunder Creator!");
    stdout.write("Enter your binding name : ");
    final binding = stdin.readLineSync();

    if (binding == null || binding.isEmpty) {
      print("Binding name cannot be empty !!");
    } else {
      _generateBinding(binding);
    }
  }

  void _generateBinding(String bindingName) {
    CreateFolderAndFiles().createFolder('lib/app/modules/$bindingName');
    final fileName =
        'lib/app/modules/$bindingName/${bindingName.toLowerCase()}_binding.dart';
    CreateFolderAndFiles().createFile(
      fileName,
      ConstStrings.instance.binding(bindingName),
    );
  }
}
