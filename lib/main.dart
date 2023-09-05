import 'package:args/args.dart';

import 'files_creator/create_module_files.dart';
import 'files_creator/init_folders.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  // create flags
  parser.addFlag('i', help: 'Initialize project with GetX and mvc');
  parser.addFlag('f',
      help: 'Initialize Folders and files without installing packages');
  parser.addFlag('m', help: 'Generate View Controller and Binding files');
  parser.addFlag('h', help: 'Generate View Controller and Binding files');

  final results = parser.parse(arguments);

  if (results['i']) {
    InitFolders().initFolders();
  } else if (results['m']) {
    CreateModuleFiles().createFiles();
  } else if (results['f']) {
    InitFolders().initFolders(setUpPackage: false);
  } else if (results['h']) {
    print("Welcome to Thunder CLI 🚀🚀");
    print("Thunder CLI is a tool to generate GetX project files");
    print("Available commands:");
    print("thunder_cli -i : Initialize project with GetX and mvc");
    print("thunder_cli -m : Generate View Controller and Binding files");
  } else {
    print(parser.usage);
  }
}
