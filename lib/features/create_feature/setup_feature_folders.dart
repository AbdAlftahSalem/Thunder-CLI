import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/create_folder.dart';

class SetupFeatureFolders {
  static void setupFeatureFolders(
      {required String featureName, required bool withApiModel}) {
    // create feature folder
    CreateFolder.createFolder(FolderPaths.instance.featureFolder);

    // create feature folder
    CreateFolder.createFolder(
        FolderPaths.instance.folderInModules(featureName));

    if (withApiModel) {
      CreateFolder.createFolder(FolderPaths.instance.modelFile(featureName));
    }
  }
}
