import 'package:args/args.dart';

import '../../../../features/create_api_model/create_api_model.dart';
import '../../../../features/create_feature/create_feature.dart';
import '../../../../features/init_project/init_project.dart';

class GetCommand {
  static void getCommand(ArgResults results, ArgParser parser) {
    if (results['i']) {
      // Initialize the project with GetX and MVC
      InitProject().initProject();
    } else if (results['m']) {
      // Generate View Controller and Binding files
      CreateFeatureFiles().createFiles();
    } else if (results['mo']) {
      // Generate model file for the module
      CreateApiModel().createApiModel();
    } else if (results['mm']) {
      // Generate View Controller and Binding files and model
      CreateFeatureFiles().createFiles();
    } else if (results['h']) {
      // Show help message
      print("Welcome to Thunder CLI 🚀🚀");
      print(
          "Thunder CLI is a tool to auto generate flutter projects folders and files");
      print("Available commands:");
      print("thunder_cli -i : Initialize project with GetX and MVC");
      print("thunder_cli -m : Generate View Controller and Binding files");
    } else {
      // Print usage if no valid flag is provided
      print(parser.usage);
    }
  }
}
