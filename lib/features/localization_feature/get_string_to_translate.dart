import 'package:thunder_cli/core/consts/folder_paths.dart';
import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';

class GetStringToTranslate {
  static Future<List<String>> getStringToTranslate() async {
    String stringConstFileContent = await FolderAndFileService.readFile(
        FolderPaths.instance.stringConstantPath,
        createFileIfNotFound: false);

    return _getWordsFromFile(stringConstFileContent);
  }

  static List<String> _getWordsFromFile(String fileContent) {
    List<String> content = fileContent.split("\n");
    List<String> wordsOutputs = [];

    for (String element in content) {
      element = element.trim();
      if ((element.startsWith("static const") ||
              element.startsWith("String") ||
              element.startsWith("final")) &&
          element.endsWith(";")) {
        String word = element
            .split("=")
            .last
            .trim()
            .replaceAll('"', "")
            .replaceAll("'", "")
            .replaceAll(";", "");
        wordsOutputs.add(word);
      }
    }
    print("🚀 Thunder extract ${wordsOutputs.length} words successfully ...\n\n");
    return wordsOutputs;
  }
}
