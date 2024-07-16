import 'dart:io';

class CreateFolderAndFiles {
  void createFile(String fileName, dynamic content) {
    final file = File(fileName);
    file.writeAsStringSync(content);
  }

  void createFolder(String folderPath) {
    final directory = Directory(folderPath);
    directory.createSync();
  }
}
