class FolderPaths {
  //  *******  app files and folders path  *******

  // create singleton for FolderPaths
  static final FolderPaths instance = FolderPaths._internal();

  factory FolderPaths() => instance;

  FolderPaths._internal();

  String featureFolder = 'E:/Flutter new/juser/lib/feature';
  String bindingsFile = 'E:/Flutter new/juser/lib/core/bindings/bindings_app.dart';

  // routes files
  String appRoutesFile = 'E:/Flutter new/juser/lib/core/routing/app_routes.dart';
  String repoFolder = 'E:/Flutter new/juser/lib/app/repos';
  String modelsFolder = 'E:/Flutter new/juser/lib/app/models';
  String uiFolder = 'E:/Flutter new/juser/lib/app/ui';
  String controllersFolder = 'E:/Flutter new/juser/lib/app/controllers';

  String routesFile = 'E:/Flutter new/juser/lib/core/routing/routes.dart';
  String jsonFile = 'E:/Flutter new/juser/lib/thunder.json';

  String apiConstRoutesFile = "E:/Flutter new/juser/lib/helper/constants/api_constants.dart";

  String stringConstantPath = "E:/Flutter new/juser/lib/helper/constants/strings_constants.dart";

  // feature files
  String repoFile(String name) =>
      '$repoFolder/${name.toLowerCase()}_repo.dart';

  String controllerFile(String name) =>
      '$controllersFolder/${name.toLowerCase()}_controller.dart';

  String viewFile(String name) =>
      '$uiFolder/${name.toLowerCase()}_view.dart';

  String modelFile(String modelName, String featureName) =>
      '$modelsFolder/models/${modelName.toLowerCase()}_model.dart';

  String translationFile(String fileName) =>
      'E:/Flutter new/juser/lib/helper/translations/${fileName}_translation.dart';

  String locale() => "E:/Flutter new/juser/lib/helper/translations/local.dart";
}
