import '../consts/const.dart';
import '../consts/folder_paths.dart';
import '../services/create_folder_files.dart';
import 'create_module_files.dart';

class SetupAppFolder {
  void setupAppFolder() {
    // create app folder
    CreateFolderAndFiles().createFolder(FolderPaths.appFolder);

    // create utils folder
    CreateFolderAndFiles().createFolder(FolderPaths.utilFolder);

    // create config folder
    CreateFolderAndFiles().createFolder(FolderPaths.configFolder);

    _setUpAppFiles();

    print("⚡⚡ Set up all files in app folder successfully\n\n");
  }

  void _setUpAppFiles() async {
    // set up components folder
    _setUpComponentsFolder();

    // set data folder
    _setUpDateFolder();

    // setup routes folder
    _setUpRoutesFolder();

    // set up modules folder
    CreateModuleFiles().createFiles(createDefault: true);
  }

  Future<void> _setUpRoutesFolder() async {
    // create routes folder
    CreateFolderAndFiles().createFolder(FolderPaths.routesFolder);

    // create app_routes file
    CreateFolderAndFiles().createFile(
      FolderPaths.appRoutesFile,
      '',
    );

    // create routes file
    CreateFolderAndFiles().createFile(
      FolderPaths.routesFile,
      '',
    );
  }

  Future<void> _setUpDateFolder() async {
    // create data folder
    CreateFolderAndFiles().createFolder(FolderPaths.dataFolder);
    CreateFolderAndFiles().createFolder(FolderPaths.localFolder);

    // create my_shared_pref file
    CreateFolderAndFiles().createFile(
      FolderPaths.sharedPrefFile,
      ConstStrings.instance.sharedPrefs,
    );

    // create hive file
    CreateFolderAndFiles().createFile(
      FolderPaths.hiveFile,
      ConstStrings.instance.hive,
    );

    print("Set all files in app/data/locale folder successfully 🚀🚀");

    // create remote folder
    CreateFolderAndFiles().createFolder(FolderPaths.remoteFolder);

    // create api_call_status file
    CreateFolderAndFiles().createFile(
      FolderPaths.apiCallStateFile,
      ConstStrings.instance.apiCallStatus,
    );

    // create api_exceptions file
    CreateFolderAndFiles().createFile(
      FolderPaths.apiExceptionFile,
      ConstStrings.instance.apiException,
    );

    // create base_client file
    CreateFolderAndFiles().createFile(
      FolderPaths.baseClientFile,
      ConstStrings.instance.baseClient,
    );

    // create models folder
    CreateFolderAndFiles().createFolder(FolderPaths.modelsFolder);
  }

  Future<void> _setUpComponentsFolder() async {
    // create components folder
    CreateFolderAndFiles().createFolder(
      FolderPaths.componentsFolder,
    );

    // create api_error_widget file
    CreateFolderAndFiles().createFile(
      FolderPaths.apiErrorWidgetFile,
      ConstStrings.instance.apiErrorWidget,
    );

    // create custom_snackbar file
    CreateFolderAndFiles().createFile(
      FolderPaths.snackbarWidgetFile,
      ConstStrings.instance.snackbar,
    );

    // create animated widget
    CreateFolderAndFiles().createFile(
      FolderPaths.animatedWidgetFile,
      ConstStrings.instance.animatedWidget,
    );

    print("Set all files in app/components folder successfully 🚀🚀");
  }
}
