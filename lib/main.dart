import 'package:args/args.dart';

import 'files_creator/create_module_files.dart';
import 'files_creator/init_folders.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  // create flags
  parser.addFlag('i', help: 'Initialize project with GetX and mvc');
  parser.addFlag('m', help: 'Generate View Controller and Binding files');

  final results = parser.parse(arguments);

  if (results['i']) {
    InitFolders().initFolders();
  } else if (results['m']) {
    CreateModuleFiles().createFiles();
  } else {
    print("Please enter a valid command [ --i / --a ]");
  }
}
