class FolderPaths {
  //  *******  app files and folders path  *******

  // create singleton for FolderPaths
  static final FolderPaths instance = FolderPaths._internal();

  factory FolderPaths() => instance;

  FolderPaths._internal();

  String featureFolder = 'lib/feature';
  String bindingsFile = 'lib/core/bindings/bindings_app.dart';

  // routes files
  String appRoutesFile = 'lib/core/routing/app_routes.dart';
  String routesFile = 'lib/core/routing/routes.dart';
  String jsonFile = 'lib/thunder.json';

  String apiConstRoutesFile = "lib/helper/constants/api_constants.dart";

  // feature files
  String folderInFeatures(String name) => 'lib/feature/$name';

  String logicFolder(String name) => "lib/feature/$name/logic";

  String uiFolder(String name) => "lib/feature/$name/ui";

  String dataFolder(String name) => "lib/feature/$name/data";

  String modelsFolder(String name) => "lib/feature/$name/data/models";

  String repoFolder(String name) => "lib/feature/$name/data/repo";

  String repoFile(String name) =>
      'lib/feature/$name/data/repo/${name.toLowerCase()}_repo.dart';

  String controllerFile(String name) =>
      'lib/feature/$name/logic/${name.toLowerCase()}_controller.dart';

  String viewFile(String name) =>
      'lib/feature/$name/ui/${name.toLowerCase()}_view.dart';

  String modelFile(String modelName, String featureName) =>
      'lib/feature/${featureName.toLowerCase()}/data/models/${modelName.toLowerCase()}_model.dart';
}
