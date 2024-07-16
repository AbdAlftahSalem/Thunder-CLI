import '../../consts/folder_paths.dart';
import '../../services/create_folder_files.dart';

class SetupFeatureFolders {
  static void setupFeatureFolders(
      {required String featureName, required bool withApiModel}) {
    // create feature folder
    CreateFolderAndFiles().createFolder(FolderPaths.instance.featureFolder);

    // create feature folder
    CreateFolderAndFiles()
        .createFolder(FolderPaths.instance.folderInModules(featureName));

    if (withApiModel) {
      CreateFolderAndFiles()
          .createFolder(FolderPaths.instance.modelFile(featureName));
    }
  }
}
