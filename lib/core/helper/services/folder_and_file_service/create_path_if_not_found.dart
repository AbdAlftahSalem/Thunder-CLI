import 'dart:io';

import 'folder_and_file_service.dart';

class CreatePathIfNotFound {
  // TODO : we want to refactor this code and apply it in whole of the code
  /// When read or write in files . file must found . this method to create file or folder if not found
  static createIt(String filePath, {bool createFile = false}) async {
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
    if (createFile) {
      FolderAndFileService.createFile(filePath, '');
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
