import 'package:thunder_cli/core/consts/folder_paths.dart';
import 'package:thunder_cli/core/services/folder_and_file_service/folder_and_file_service.dart';

import '../../core/models/from_to_language_model.dart';

class SetupLanguagesFiles {
  static Future setupLanguagesFiles(
      FromToLanguageModel fromToLanguageModel) async {
    // setup base language
    await FolderAndFileService.createFile(
      FolderPaths.instance.translationFile(fromToLanguageModel.baseLanguage.substring(0,2)),
      "import '../constants/strings_constants.dart';\n\nfinal Map<String, String> ${fromToLanguageModel.baseLanguage.substring(0,2)}Language = {};",
    );

    // setup to languages
    for (var i in fromToLanguageModel.toLanguages) {
      await FolderAndFileService.createFile(
        FolderPaths.instance.translationFile(i.languageDartFileName),
        "import '../constants/strings_constants.dart';\n\nfinal Map<String, String> ${i.languageName}Language = {};",
      );
    }
  }
}
