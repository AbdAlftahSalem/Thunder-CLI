class FolderPaths {
  //  *******  app files and folders path  *******

  // create singleton for FolderPaths
  static final FolderPaths instance = FolderPaths._internal();

  factory FolderPaths() => instance;

  FolderPaths._internal();

  String featureFolder = 'lib/app/feature';

  // models files
  String modelFile(String name) =>
      'lib/app/data/models/${name.toLowerCase()}_model.dart';

  // routes files
  String appRoutesFile = 'lib/app/routes/app_routes.dart';
  String routesFile = 'lib/app/routes/routes.dart';
  String jsonFile = 'thunder.json';

  // feature files
  String folderInModules(String name) => 'lib/app/feature/$name';

  String controllerFolder(String name) => "lib/app/feature/$name/controller";

  String viewFolder(String name) => "lib/app/feature/$name/view";

  String controllerFile(String name) =>
      'lib/app/feature/$name/${name.toLowerCase()}_controller.dart';

  String viewFile(String name) =>
      'lib/app/feature/$name/${name.toLowerCase()}_view.dart';
}
