class FolderPaths {
  //  *******  app files and folders path  *******

  // create singleton for FolderPaths
  static final FolderPaths instance = FolderPaths._internal();

  factory FolderPaths() => instance;

  FolderPaths._internal();

  String featureFolder = 'E:/Flutter new/dabdob/lib/feature';
  String bindingsFile =
      'E:/Flutter new/dabdob/lib/core/bindings/bindings_app.dart';

  // routes files
  String appRoutesFile =
      'E:/Flutter new/dabdob/lib/core/routing/app_routes.dart';
  String routesFile = 'E:/Flutter new/dabdob/lib/core/routing/routes.dart';
  String jsonFile = 'E:/Flutter new/dabdob/lib/thunder.json';

  String apiConstRoutesFile =
      "E:/Flutter new/dabdob/lib/helper/constants/api_constants.dart";

  String stringConstantPath = "E:/Flutter new/dabdob/lib/helper/constants/strings_constants.dart";

  // feature files
  String folderInFeatures(String name) =>
      'E:/Flutter new/dabdob/lib/feature/$name';

  String logicFolder(String name) =>
      "E:/Flutter new/dabdob/lib/feature/$name/logic";

  String uiFolder(String name) => "E:/Flutter new/dabdob/lib/feature/$name/ui";

  String dataFolder(String name) =>
      "E:/Flutter new/dabdob/lib/feature/$name/data";

  String modelsFolder(String name) =>
      "E:/Flutter new/dabdob/lib/feature/$name/data/models";

  String repoFolder(String name) =>
      "E:/Flutter new/dabdob/lib/feature/$name/data/repo";

  String repoFile(String name) =>
      'E:/Flutter new/dabdob/lib/feature/$name/data/repo/${name.toLowerCase()}_repo.dart';

  String controllerFile(String name) =>
      'E:/Flutter new/dabdob/lib/feature/$name/logic/${name.toLowerCase()}_controller.dart';

  String viewFile(String name) =>
      'E:/Flutter new/dabdob/lib/feature/$name/ui/${name.toLowerCase()}_view.dart';

  String modelFile(String modelName, String featureName) =>
      'E:/Flutter new/dabdob/lib/feature/${featureName.toLowerCase()}/data/models/${modelName.toLowerCase()}_model.dart';

  String translationFile(String fileName) =>
      'E:/Flutter new/dabdob/lib/helper/translations/$fileName.dart';

}
