import 'dart:io';

import 'package:thunder_cli/core/extensions/string_extensions.dart';
import 'package:thunder_cli/features/create_feature/setup_feature_files.dart';
import 'package:thunder_cli/features/create_feature/setup_feature_folders.dart';

import '../routes_feature/route_feature.dart';

class CreateFeatureFiles {
  static void createFiles() {
    stdout.write("Enter your feature name : ");
    String featureName = "";
    while (featureName.isEmpty) {
      featureName = (stdin.readLineSync() ?? "")
          .trim()
          .checkIfEmptyAndNullAndShowMessage("😢 Name name cannot be empty !!");
    }
    if (featureName.isNotEmpty) {
      _generateFiles(featureName.replaceAll(" ", "_").replaceAll("-", "_"));
    }
  }

   static Future<void> _generateFiles(String featureName) async {
    print("\n******************** $featureName ********************\n");
    // set up modules folder
    await SetupFeatureFolders.setupFeatureFolders(featureName: featureName);
    print("✅ Setup 'Folders' and 'Sub Folders' successfully ...");

    await SetupFeatureFiles.setupFeatureFiles(featureName);
    print("✅ Setup 'Files' successfully ...");

    await RouteFeature.setRoutes(featureName);
    print(
        "✅ Add feature in 'app_routes.dart' and 'routes.dart' successfully ...");

    print(
        "\n⚡ Setup '$featureName' Successfully ...\n");

    print("  ✅ Add view template .");
    print("  ✅ Add controller and connect with view .");
    print("  ✅ Add controller and connect with view .");
    print("  ✅ Create binding for feature  ( DI ).");
    print("  ✅ Create route .");
    print("  ✅ Set up model folder ( empty ) . ");
    print("  ✅ Set up template repo folder and file . \n\n");
  }
}
