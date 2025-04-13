class FolderPaths {
  //  *******  app files and folders path  *******

  // create singleton for FolderPaths
  static final FolderPaths instance = FolderPaths._internal();

  factory FolderPaths() => instance;

  FolderPaths._internal();

  String featureFolder = 'lib/app/features/';
  String bindingsFile = 'lib/core/bindings/bindings_app.dart';

  // routes files
  String appRoutesFile = 'lib/core/routing/app_routes.dart';
  String repoFolder = 'lib/app/repositories/';
  String modelsFolder = 'lib/app/models';
  String uiFolder = 'lib/app/features';
  String controllersFolder = 'lib/app/features';

  String routesFile = 'lib/core/routing/routes.dart';
  String jsonFile = 'lib/thunder.json';

  String apiConstRoutesFile = "lib/helper/constants/api_constants.dart";

  String stringConstantPath = "lib/helper/constants/strings_constants.dart";

  // feature files
  String repoFile(String name) =>
      '$repoFolder/${name.toLowerCase()}_repo.dart';

  String controllerFile(String name) =>
      '$controllersFolder/${name.toLowerCase()}_controller.dart';

  String viewFile(String name) =>
      '$uiFolder/${name.toLowerCase()}_view.dart';

  String modelFile(String modelName, String featureName) =>
      '$modelsFolder/${modelName.toLowerCase()}_model.dart';

  String translationFile(String fileName) =>
      'lib/helper/translations/${fileName}_translation.dart';

  String locale() => "lib/helper/translations/local.dart";
}
