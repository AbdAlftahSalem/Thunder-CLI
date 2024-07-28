import 'dart:io';

import 'folder_and_file_service.dart';

class CreatePathIfNotFound {
  // TODO : we want to refactor this code
  /// When read or write in files . file must found . this method to create file or folder if not found
  static createIt(String filePath, {bool createFile = false}) async {
    List<String> preFolders = filePath.split("/");
    preFolders.removeWhere((element) => element.endsWith(".dart"));

    for (int folderIndex = 0; folderIndex <= preFolders.length; ++folderIndex) {
      String path = _joinPath(preFolders, folderIndex);
      if (path.isNotEmpty) {
        final directory = Directory(path);

        if (!(await directory.exists())) {
          await FolderAndFileService.createFolder(path);
          print('📂 Create $path folder successfully 🎉 ...');
        }
      }
    }
    if (createFile) {
      await FolderAndFileService.createFile(filePath, '');
    }
  }

  static _joinPath(List<String> paths, currentIndex) {
    String path = '';
    for (int i = 0; i < currentIndex; ++i) {
      path += "${paths[i]}/";
    }
    return path;
  }
}
