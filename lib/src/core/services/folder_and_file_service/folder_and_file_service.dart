import 'dart:io';

/// File system helpers used by every generator.
class FolderAndFileService {
  /// Creates (or overwrites) the file at [filePath] with [content].
  /// Missing parent folders are created.
  static Future<void> createFile(String filePath, String content) async {
    final file = File(filePath);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
  }

  /// Creates the folder at [folderPath] (and its parents).
  static Future<void> createFolder(String folderPath) async {
    if (folderPath.isEmpty) return;
    await Directory(folderPath).create(recursive: true);
  }

  /// Reads the file at [filePath]. Returns an empty string when the file
  /// does not exist.
  static Future<String> readFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return '';
    return file.readAsString();
  }

  /// Returns `true` when a file exists at [filePath].
  static bool exists(String filePath) => File(filePath).existsSync();
}
