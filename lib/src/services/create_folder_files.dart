import 'dart:io';

class CreateFolderAndFiles {
  void createFile(String fileName, String content) {
    final file = File(fileName);
    file.writeAsStringSync(content);
  }

  void createFolder(String folderName) {
    final directory = Directory(folderName);
    directory.createSync();
  }
}
