import 'dart:io';

class CreateFolderAndFiles {
  void createFile(String fileName, dynamic content) {
    final file = File(fileName);
    file.writeAsStringSync(content);
  }

  void createFolder(String folderName) {
    final directory = Directory(folderName);
    directory.createSync();
  }
}
