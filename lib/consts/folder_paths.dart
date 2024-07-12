class FolderPaths {
  //  *******  app files and folders  *******

  // create singleton for FolderPaths
  static final FolderPaths instance = FolderPaths._internal();

  factory FolderPaths() => instance;

  FolderPaths._internal();

  String modulesFolder = 'lib/app/modules';

  // models files
  String modelFile(String name) =>
      'lib/app/data/models/${name.toLowerCase()}_model.dart';

  // routes files
  String appRoutesFile = 'lib/app/routes/app_routes.dart';
  String routesFile = 'lib/app/routes/routes.dart';
  String jsonFile = 'thunder.json';

  // module files
  String folderInModules(String name) => 'lib/app/modules/$name';

  String controllerFolder(String name) => "lib/app/modules/$name/controller";

  String viewFolder(String name) => "lib/app/modules/$name/view";

  String bindingFolder(String name) => "lib/app/modules/$name/binding";

  String bindingFile(String name) =>
      'lib/app/modules/$name/${name.toLowerCase()}_binding.dart';

  String controllerFile(String name) =>
      'lib/app/modules/$name/${name.toLowerCase()}_controller.dart';

  String viewFile(String name) =>
      'lib/app/modules/$name/${name.toLowerCase()}_view.dart';
}
