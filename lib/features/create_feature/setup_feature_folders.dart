import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/folder_and_file_service.dart';

class SetupFeatureFolders {
  static void setupFeatureFolders(
      {required String featureName, required bool withApiModel}) {
    // create feature folder
    FolderAndFileService.createFolder(FolderPaths.instance.featureFolder);

    // create feature folder
    FolderAndFileService.createFolder(
        FolderPaths.instance.folderInModules(featureName));

    if (withApiModel) {
      FolderAndFileService.createFolder(
          FolderPaths.instance.modelFile(featureName));
    }
  }
}
