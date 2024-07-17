import 'dart:io';

class CreateFolder {
  static createFolder(String folderPath) {
    try {
      final directory = Directory(folderPath);
      directory.createSync();
    } catch (e) {
      print("😅 Error when create or write in $folderPath");
    }
  }
}
