class FolderPaths {
  //  *******  app files and folders path  *******

  // create singleton for FolderPaths
  static final FolderPaths instance = FolderPaths._internal();

  factory FolderPaths() => instance;

  FolderPaths._internal();

  String featureFolder = 'E:/Flutter new/test/lib/feature';
  String bindingsFile = 'E:/Flutter new/test/lib/core/bindings/bindings_app.dart';

  // routes files
  String appRoutesFile = 'E:/Flutter new/test/lib/core/routing/app_routes.dart';
  String repoFolder = 'E:/Flutter new/test/lib/app/repositories/';
  String modelsFolder = 'E:/Flutter new/test/lib/app/models';
  String uiFolder = 'E:/Flutter new/test/lib/app/ui';
  String controllersFolder = 'E:/Flutter new/test/lib/app/controllers';

  String routesFile = 'E:/Flutter new/test/lib/core/routing/routes.dart';
  String jsonFile = 'E:/Flutter new/test/lib/thunder.json';

  String apiConstRoutesFile = "E:/Flutter new/test/lib/helper/constants/api_constants.dart";

  String stringConstantPath = "E:/Flutter new/test/lib/helper/constants/strings_constants.dart";

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
      'E:/Flutter new/test/lib/helper/translations/${fileName}_translation.dart';

  String locale() => "E:/Flutter new/test/lib/helper/translations/local.dart";
}
