import 'dart:io';

import 'create_path_if_not_found.dart';

class FolderAndFileService {
  static Future createFile(String filePath, dynamic content) async {
    try {
      final file = File(filePath);
      file.writeAsStringSync(content);
    } on PathNotFoundException catch (e) {
      print("$filePath not found , Thunder will create it 🚀\n\n");
      await CreatePathIfNotFound.createIt(filePath);

      final file = File(filePath);
      file.writeAsStringSync(content);
    }
  }

  static Future createFolder(String folderPath) async {
    try {
      if (folderPath.isNotEmpty) {
        final directory = Directory(folderPath);
        directory.createSync();
      }
    } on PathNotFoundException catch (e) {
      print("$folderPath not found , Thunder will create it 🚀 \n");
      await CreatePathIfNotFound.createIt(folderPath);
    }
  }

}
