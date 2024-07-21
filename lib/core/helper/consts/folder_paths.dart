class FolderPaths {
  //  *******  app files and folders path  *******

  // create singleton for FolderPaths
  static final FolderPaths instance = FolderPaths._internal();

  factory FolderPaths() => instance;

  FolderPaths._internal();

  String featureFolder = 'lib/app/feature';
  String bindingsFile = 'lib/core/bindings/bindings_app.dart';

  // models files
  String modelFile(String name) =>
      'lib/feature/${name.toLowerCase()}/data/models/${name.toLowerCase()}model.data';

  // routes files
  String appRoutesFile = 'lib/core/routing/app_routes.dart';
  String routesFile = 'lib/core/routing/routes.dart';
  String jsonFile = 'lib/thunder.json';

  // feature files
  String folderInFeatures(String name) => 'lib/app/feature/$name';

  String logicFolder(String name) => "lib/app/feature/$name/logic";

  String uiFolder(String name) => "lib/app/feature/$name/ui";

  String dataFolder(String name) => "lib/app/feature/$name/data";

  String modelsFolder(String name) => "lib/app/feature/$name/data/models";

  String repoFolder(String name) => "lib/app/feature/$name/data/repo";

  String controllerFile(String name) =>
      'lib/app/feature/$name/logic/${name.toLowerCase()}_controller.dart';

  String viewFile(String name) =>
      'lib/app/feature/$name/ui/${name.toLowerCase()}_view.dart';
}
