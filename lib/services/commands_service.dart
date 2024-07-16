import 'package:args/args.dart';

import '../features/create_api_model/create_api_model.dart';
import '../features/create_feature/create_feature.dart';
import '../features/init_project/init_project.dart';

class CommandServices {

  static startCommands(List<String> arguments){
    final parser = ArgParser();

    // Add flags to the argument parser
    parser
      ..addFlag('i', help: 'Initialize project Thunder CMD')
      ..addFlag('m', help: 'Generate View Controller and Binding files')
      ..addFlag('mm',
          help: 'Generate View Controller and Binding files and model')
      ..addFlag('mo', help: 'Generate model file for the module')
      ..addFlag('h', help: 'Show help message');

    final results = parser.parse(arguments);

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
      CreateFeatureFiles(withApiModel: true).createFiles();
    } else if (results['h']) {
      // Show help message
      print("Welcome to Thunder CLI 🚀🚀");
      print("Thunder CLI is a tool to auto generate flutter projects folders and files");
      print("Available commands:");
      print("thunder_cli -i : Initialize project with GetX and MVC");
      print("thunder_cli -m : Generate View Controller and Binding files");
    } else {
      // Print usage if no valid flag is provided
      print(parser.usage);
    }
  }

}