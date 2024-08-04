import 'package:args/args.dart';

import '../../../../features/create_api_model/create_api_model.dart';
import '../../../../features/create_feature/create_feature.dart';
import '../../../../features/init_project/init_project.dart';

class GetCommand {
  static void getCommand(ArgResults results, ArgParser parser) {
    if (results['init']) {
      // Initialize the project -> thunder_cli --i
      InitProject().initProject();
    } else if (results['feature']) {
      // Generate Feature -> thunder_cli --m
      CreateFeatureFiles().createFiles();
    } else if (results['model']) {
      // Generate model file for the module -> thunder_cli --model
      CreateApiModel().createApiModel();
    } else {
      _showHelpMessage();
    }
  }

  /// Show help message -> thunder_cli --h
  static void _showHelpMessage() {
    String message = "⚡ Welcome to Thunder CLI 🚀🚀\n";
    message +=
        "⚡ Thunder CLI is a tool to create flutter project and auto generate files and folders\n\n";

    message += "⚡ Available commands: ";
    message += "1- thunder_cli --i : Initialize flutter project.";
    message +=
        "2- thunder_cli --feature : Create a new feature and handle UI , controllers , repos , DI and routing.";
    message +=
        "3- thunder_cli --model : create a new API model with API automatically.";
    message += "4- thunder_cli --help : Show help message.";

    print(message);
  }
}
