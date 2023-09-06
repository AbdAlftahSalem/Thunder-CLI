import 'package:args/args.dart';
import 'files_creator/create_models.dart';
import 'files_creator/create_module_files.dart';
import 'files_creator/init_folders.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  // Add flags to the argument parser
  parser
    ..addFlag('i', help: 'Initialize project with GetX and MVC')
    ..addFlag('f',
        help: 'Initialize folders and files without installing packages')
    ..addFlag('m', help: 'Generate View Controller and Binding files')
    ..addFlag('mm',
        help: 'Generate View Controller and Binding files and model')
    ..addFlag('mo', help: 'Generate model file for the module')
    ..addFlag('h', help: 'Show help message');

  final results = parser.parse(arguments);

  if (results['i']) {
    // Initialize the project with GetX and MVC
    InitFolders().initFolders();
  } else if (results['m']) {
    // Generate View Controller and Binding files
    CreateModuleFiles().createFiles();
  } else if (results['f']) {
    // Initialize folders and files without installing packages
    InitFolders().initFolders(setUpPackage: false);
  } else if (results['mo']) {
    // Generate model file for the module
    CreateModels().createModelFile();
  } else if (results['mm']) {
    // Generate View Controller and Binding files and model
    CreateModuleFiles(withModel: true).createFiles();
  } else if (results['h']) {
    // Show help message
    print("Welcome to Thunder CLI 🚀🚀");
    print("Thunder CLI is a tool to generate GetX project files");
    print("Available commands:");
    print("thunder_cli -i : Initialize project with GetX and MVC");
    print("thunder_cli -m : Generate View Controller and Binding files");
  } else {
    // Print usage if no valid flag is provided
    print(parser.usage);
  }
}
