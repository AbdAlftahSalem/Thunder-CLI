import 'dart:io';

import 'package:thunder_cli/features/create_feature/setup_feature_files.dart';
import 'package:thunder_cli/features/create_feature/setup_feature_folders.dart';

import '../create_api_model/create_api_model.dart';
import '../routes_feature/route_feature.dart';

class CreateFeatureFiles {
  bool withApiModel;

  CreateFeatureFiles({this.withApiModel = false});

  void createFiles({bool createDefault = false}) {
    if (createDefault) {
      _generateFiles("login");
      return;
    }
    stdout.write("Enter your view name ( login , bottom_van ) : ");
    final className = stdin.readLineSync();

    if (className == null || className.isEmpty) {
      print("😢 Name name cannot be empty !!");
    } else {
      _generateFiles(className);
    }
  }

  _generateFiles(String className) {
    // set up modules folder
    SetupFeatureFolders.setupFeatureFolders(
      featureName: className,
      withApiModel: withApiModel,
    );

    // set up files module
    SetupFeatureFiles.setupFeatureFiles(className);

    try {
      // reading routes file
      RouteFeature(nameFolder: className);
    } catch (e) {
      print('😢 Error in create routes . \n $e');
    }

    if (withApiModel) {
      CreateApiModel().createApiModel();
    }

    print("⚡ Create module files successfully\n\n");
  }
}
