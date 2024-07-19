import 'dart:io';

import 'folder_and_file_service.dart';

class CreatePathIfNotFound {
  // TODO : we want to refactor this code and apply it in whole of the code
  static createIt(String filePath) async {
    List<String> preFolders = filePath.split("/");
    preFolders.removeWhere((element) => element.endsWith(".dart"));

    for (int folderIndex = 0; folderIndex <= preFolders.length; ++folderIndex) {
      final directory = Directory(joinPath(preFolders, folderIndex));

      if (!(await directory.exists())) {
        FolderAndFileService.createFolder(joinPath(preFolders, folderIndex));
        print(
            '✅ Create ${joinPath(preFolders, folderIndex)} folder successfully 🎉 ...');
      }
    }
  }

  static joinPath(List<String> paths, currentIndex) {
    String path = '';
    for (int i = 0; i < currentIndex; ++i) {
      path += "${paths[i]}/";
    }
    return path;
  }
}
