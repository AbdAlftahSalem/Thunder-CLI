import '../../core/helper/consts/folder_paths.dart';
import '../../core/helper/services/folder_and_file_service/folder_and_file_service.dart';

class SetupFeatureFolders {
  static Future<void> setupFeatureFolders({required String featureName}) async {
    // create feature folder
    await FolderAndFileService.createFolder(FolderPaths.instance.featureFolder);

    await FolderAndFileService.createFolder(
      FolderPaths.instance.logicFolder(featureName),
    );
    await FolderAndFileService.createFolder(
      FolderPaths.instance.uiFolder(featureName),
    );
    await FolderAndFileService.createFolder(
      FolderPaths.instance.dataFolder(featureName),
    );
    await FolderAndFileService.createFolder(
      FolderPaths.instance.repoFolder(featureName),
    );
    await FolderAndFileService.createFolder(
      FolderPaths.instance.modelsFolder(featureName),
    );
  }
}
