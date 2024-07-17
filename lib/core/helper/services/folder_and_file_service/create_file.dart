import 'dart:io';

class CreateFile {
  static void createFile(String fileName, dynamic content) {
    try {
      final file = File(fileName);
      file.writeAsStringSync(content);
    }catch (e){
      print("😅 Error when create or write in $fileName");
    }

  }
}
