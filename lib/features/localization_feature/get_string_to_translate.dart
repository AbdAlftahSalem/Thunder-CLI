import 'package:thunder_cli/core/consts/folder_paths.dart';
import 'package:thunder_cli/core/extensions/app_data_extesions.dart';
import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';

import '../init_project/models/app_data_model.dart';
import 'models/localization_variables_name.dart';

class GetStringToTranslate {
  static Future<LocalizationVariablesNameAndWords> getStringToTranslate(
      AppDataModel appDataModel) async {
    LocalizationVariablesNameAndWords localizationVariablesName =
        LocalizationVariablesNameAndWords();

    String stringConstFileContent = await FolderAndFileService.readFile(
        FolderPaths.instance.stringConstantPath,
        createFileIfNotFound: false);

    localizationVariablesName.wordsKeys =
        _getWordsFromFile(stringConstFileContent);

    localizationVariablesName.variables =
        _getVariablesName(stringConstFileContent);

    appDataModel.localizationModel!.lastWordTranslated =
        (localizationVariablesName.wordsKeys ?? [""]).last;
    await appDataModel.saveModel();

    return localizationVariablesName;
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
    print(
        "🚀 Thunder extract ${wordsOutputs.length} words successfully ...\n\n");
    return wordsOutputs;
  }

  static List<String> _getVariablesName(String fileContent) {
    List<String> variables = [];
    List<String> content = fileContent.split("\n");

    for (String element in content) {
      element = element.trim();
      if ((element.startsWith("static const") ||
              element.startsWith("String") ||
              element.startsWith("final")) &&
          element.endsWith(";")) {
        String fullVariable = element.split("=").first;
        String variableName = fullVariable.split("String").last.trim();
        variables.add(variableName);
      }
    }

    return variables;
  }
}
