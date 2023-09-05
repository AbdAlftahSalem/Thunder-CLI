import '../consts/const.dart';
import '../services/create_folder_files.dart';
import 'create_module_files.dart';

class SetupAppFolder {
  void setupAppFolder() {
    // create app folder
    CreateFolderAndFiles().createFolder('app');

    // create utils folder
    CreateFolderAndFiles().createFolder('utils');

    // create config folder
    CreateFolderAndFiles().createFolder('config');

    print("Create base folders successfully 🚀🚀");

    _setUpAppFiles();
  }

  void _setUpAppFiles() async {
    // set up components folder
    await _setUpComponentsFolder();

    // set data folder
    await _setUpDateFolder();

    // setup routes folder
    await _setUpRoutesFolder();

    // set up modules folder
    CreateModuleFiles().createFiles();
  }

  Future<void> _setUpRoutesFolder() async {
    // create routes folder
    CreateFolderAndFiles().createFolder('app/routes');

    // create app_routes file
    CreateFolderAndFiles().createFile(
      'app/routes/app_routes.dart',
      '',
    );

    // create routes file
    CreateFolderAndFiles().createFile(
      'app/routes/routes.dart',
      '',
    );
  }

  Future<void> _setUpDateFolder() async {
    // create data folder
    CreateFolderAndFiles().createFolder('app/data');
    CreateFolderAndFiles().createFolder('app/data/local');

    // create my_shared_pref file
    CreateFolderAndFiles().createFile(
      'app/data/local/my_shared_pref.dart',
      ConstStrings.instance.sharedPrefs,
    );

    // create hive file
    CreateFolderAndFiles().createFile(
      'app/data/local/hive.dart',
      ConstStrings.instance.hive,
    );

    await Future.delayed(Duration(milliseconds: 500));

    print("Set all files in app/data/locale folder successfully 🚀🚀");

    // create remote folder
    CreateFolderAndFiles().createFolder('app/data/remote');

    // create api_call_status file
    CreateFolderAndFiles().createFile(
      'app/data/remote/api_call_status.dart',
      ConstStrings.instance.apiCallStatus,
    );

    // create api_exceptions file
    CreateFolderAndFiles().createFile(
      'app/data/remote/api_exceptions.dart',
      ConstStrings.instance.apiException,
    );

    // create base_client file
    CreateFolderAndFiles().createFile(
      'app/data/remote/base_client.dart',
      ConstStrings.instance.baseClient,
    );
  }

  Future<void> _setUpComponentsFolder() async {
    // create components folder
    CreateFolderAndFiles().createFolder(
      'app/components',
    );

    // create api_error_widget file
    CreateFolderAndFiles().createFile(
      'app/components/api_error_widget.dart',
      ConstStrings.instance.apiErrorWidget,
    );

    // create custom_snackbar file
    CreateFolderAndFiles().createFile(
      'app/components/custom_snackbar.dart',
      ConstStrings.instance.snackbar,
    );

    // create animated widget
    CreateFolderAndFiles().createFile(
      'app/components/animated_widget.dart',
      ConstStrings.instance.animatedWidget,
    );

    await Future.delayed(Duration(milliseconds: 500));

    print("Set all files in app/components folder successfully 🚀🚀");
  }
}
