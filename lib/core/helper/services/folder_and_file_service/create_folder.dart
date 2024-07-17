import 'dart:io';

class CreateFolder {
  static createFolder(String folderPath) {
    final directory = Directory(folderPath);
    directory.createSync();
  }
}
