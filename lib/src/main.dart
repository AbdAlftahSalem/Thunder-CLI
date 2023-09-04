import 'package:args/args.dart';

import './files_creator/create_binding.dart';
import './files_creator/create_controller.dart';
import './files_creator/create_view.dart';
import './files_creator/generate_all_files.dart';
import './files_creator/init_folders.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  // create flags
  parser.addFlag('i', help: 'Initialize project with GetX and mvc');
  parser.addFlag('a', help: 'Generate View Controller and Binding files');
  parser.addFlag('c', help: 'Generate controller file');
  parser.addFlag('v', help: 'Generate view file');
  parser.addFlag('b', help: 'Generate Binding file');

  final results = parser.parse(arguments);

  if (results['c']) {
    CreateController().createController();
  } else if (results['i']) {
    InitFolders().initFolders();
  } else if (results['v']) {
    CreateView().createView();
  } else if (results['b']) {
    CreateBinding().createBinding();
  } else if (results['a']) {
    CreateAllFiles().createFiles();
  } else {
    print("Please enter a valid command");
  }
}
