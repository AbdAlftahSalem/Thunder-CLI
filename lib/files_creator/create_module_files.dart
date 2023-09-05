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
      ConstStrings.instance.binding(name.toCamelCase()),
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
      ConstStrings.instance.view(name.toCamelCase()),
    );

    // print success message
    print("Create $name module files successfully 🚀🚀");
  }
}
