import 'dart:io';

import 'package:thunder_cli/core/helper/services/folder_and_file_service/create_folder.dart';

class CreateFile {
  static Future createFile(String filePath, dynamic content) async {
    try {
      final file = File(filePath);
      if (!(await file.exists())) {
        print("$filePath not found , Thunder will create it 🚀");
        createIt(filePath);
      }
      final file2 = File(filePath);
      file2.writeAsStringSync(content);
    } catch (e) {
      print("😅 Error when create or write in $filePath");
    }
  }

  // TODO : we want to refactor this code and apply it in whole of the code
  static createIt(String filePath) async {
    List<String> preFolders = filePath.split("/");
    preFolders.removeWhere((element) => element.endsWith(".dart"));

    for (int folderIndex = 0; folderIndex <= preFolders.length; ++folderIndex) {
      final directory = Directory(joinPath(preFolders, folderIndex));

      if (!(await directory.exists())) {
        // print(joinPath(preFolders, folderIndex));
        print(joinPath(preFolders, folderIndex));
        CreateFolder.createFolder(joinPath(preFolders, folderIndex));
        // print("${joinPath(preFolders, folderIndex)} created ... ");
      } else {
        print("$filePath found");
      }
    }

    print(preFolders);
  }

  static joinPath(List<String> paths, currentIndex) {
    String path = '';
    for (int i = 0; i < currentIndex; ++i) {
      // print(i);
      path += "${paths[i]}/";
    }
    return path;
  }
}
