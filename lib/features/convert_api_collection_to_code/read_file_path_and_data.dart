import 'dart:convert';
import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';

class ReadFilePathAndData {
  static Future<Map<String, dynamic>> readFilePathAndData() async {
    String collectionPath = "";
    String data = "";
    while (collectionPath.isEmpty) {
      stdout.write("Enter your path for collection : ");
      collectionPath = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage(
              "😢 Collection path cannot be empty !!");
      data = await FolderAndFileService.readFile(
        collectionPath,
        createFileIfNotFound: false,
      );
      if (data.isEmpty) {
        collectionPath = "";
      }
    }
    return jsonDecode(data);
  }
}
