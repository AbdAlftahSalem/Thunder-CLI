import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/folder_and_file_service.dart';

class SetupFeatureFolders {
  static void setupFeatureFolders({required String featureName}) {
    // create feature folder
    FolderAndFileService.createFolder(FolderPaths.instance.featureFolder);
    FolderAndFileService.createFolder(
      FolderPaths.instance.logicFolder(featureName),
    );
    FolderAndFileService.createFolder(
      FolderPaths.instance.uiFolder(featureName),
    );
    FolderAndFileService.createFolder(
      FolderPaths.instance.dataFolder(featureName),
    );
    FolderAndFileService.createFolder(
      FolderPaths.instance.repoFolder(featureName),
    );
    FolderAndFileService.createFolder(
      FolderPaths.instance.modelsFolder(featureName),
    );
  }
}
