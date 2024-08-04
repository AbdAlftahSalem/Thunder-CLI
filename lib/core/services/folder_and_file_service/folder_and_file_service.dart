import 'dart:io';

import 'create_path_if_not_found.dart';

class FolderAndFileService {
  /// create file by specific path [filePath] and content [content]
  static Future createFile(String filePath, dynamic content) async {
    try {
      final file = File(filePath);
      file.writeAsStringSync(content);
    } on PathNotFoundException catch (e) {
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
        directory.createSync(recursive: true);
        print('📂 Create $folderPath folder successfully 🎉 ...');
      }
    } on PathNotFoundException catch (e) {
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
      await CreatePathIfNotFound.createIt(filePath, createFile: true);
      // reading bindings.dart file
      final file = File(filePath);
      return file.readAsStringSync();
    }
  }
}
