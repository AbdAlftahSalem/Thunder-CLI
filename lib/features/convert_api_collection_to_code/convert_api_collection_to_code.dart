import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';

import '../../core/services/folder_and_file_service/folder_and_file_service.dart';

class ConvertApiCollectionToCode {
  static void convertApiCollectionToCode() async {
    String collectionPath = "";
    while (collectionPath.isEmpty) {
      stdout.write("Enter your path for collection : ");
      collectionPath = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage(
              "😢 Collection path cannot be empty !!");
      String fileData = await FolderAndFileService.readFile(
        collectionPath,
        createFileIfNotFound: false,
      );
      if (fileData.isEmpty) {
        collectionPath = "";
      }
    }
  }
}
