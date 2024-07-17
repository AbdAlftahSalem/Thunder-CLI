import 'dart:io';

class CreateFile {
  static void createFile(String fileName, dynamic content) {
    final file = File(fileName);
    file.writeAsStringSync(content);
  }
}
