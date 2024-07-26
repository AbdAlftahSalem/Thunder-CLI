import 'dart:io';

import 'create_path_if_not_found.dart';

class FolderAndFileService {
  /// create file by specific path [filePath] and content [content]
  static Future createFile(String filePath, dynamic content) async {
    try {
      final file = File(filePath);
      file.writeAsStringSync(content);
    } on PathNotFoundException catch (e) {
      print("$filePath not found , Thunder will create it 🚀\n\n");
      await CreatePathIfNotFound.createIt(filePath, createFile: true);

      final file = File(filePath);
      file.writeAsStringSync(content);
    }
  }

  /// create folder by specific path [folderPath]
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

  /// read file content by specific [filePath]
  static Future readFile(String filePath) async {
    try {
      // reading bindings.dart file
      final file = File(filePath);

      return file.readAsStringSync();
    } on PathNotFoundException catch (e) {
      print("$filePath not found , Thunder will create it 🚀 \n");
      await CreatePathIfNotFound.createIt(filePath, createFile: true);
      // reading bindings.dart file
      final file = File(filePath);
      return file.readAsStringSync();
    }
  }
}
