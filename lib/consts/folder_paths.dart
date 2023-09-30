class FolderPaths {
  //  *******  app files and folders  *******

  static const String modulesFolder = 'lib/app/modules';

  // models files
  static String modelFile(String name) =>
      'lib/app/data/models/${name.toLowerCase()}_model.dart';

  // routes files
  static const String appRoutesFile = 'lib/app/routes/app_routes.dart';
  static const String routesFile = 'lib/app/routes/routes.dart';

  // module files
  static String folderInModules(String name) => 'lib/app/modules/$name';

  static String controllerFolder(String name) =>
      "lib/app/modules/$name/controller";

  static String viewFolder(String name) => "lib/app/modules/$name/view";

  static String bindingFolder(String name) => "lib/app/modules/$name/binding";

  static String bindingFile(String name) =>
      'lib/app/modules/$name/${name.toLowerCase()}_binding.dart';

  static String controllerFile(String name) =>
      'lib/app/modules/$name/${name.toLowerCase()}_controller.dart';

  static String viewFile(String name) =>
      'lib/app/modules/$name/${name.toLowerCase()}_view.dart';
}
