import 'dart:io';

import 'package:thunder_cli/core/helper/extensions/string_extensions.dart';
import 'package:thunder_cli/features/create_feature/setup_feature_files.dart';
import 'package:thunder_cli/features/create_feature/setup_feature_folders.dart';

import '../routes_feature/route_feature.dart';

class CreateFeatureFiles {
  void createFiles() {
    stdout.write("Enter your feature name ( login , bottom_van ) : ");
    final featureName = (stdin.readLineSync() ?? "")
        .trim()
        .checkIfEmptyAndNullAndShowMessage("😢 Name name cannot be empty !!");

    if (featureName.isNotEmpty) {
      _generateFiles(featureName);
    }
  }

  _generateFiles(String featureName) async {
    print("\n******************** $featureName ********************\n");
    // set up modules folder
    await SetupFeatureFolders.setupFeatureFolders(featureName: featureName);

    await SetupFeatureFiles.setupFeatureFiles(featureName);

    await RouteFeature.setRoutes(featureName);

    print("\n⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡ Create $featureName Files Successfully ⚡⚡⚡⚡⚡⚡⚡⚡⚡⚡\n\n");
  }
}
