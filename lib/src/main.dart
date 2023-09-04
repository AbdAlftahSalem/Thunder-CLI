import 'package:args/args.dart';

import './files_creator/create_controller.dart';
import './files_creator/create_view.dart';
import './files_creator/create_binding.dart';
import './files_creator/init_folders.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  // create flags
  parser.addFlag('init', help: 'Initialize project with GetX and mvc');
  parser.addFlag('controller', help: 'Generate controller file');
  parser.addFlag('view', help: 'Generate view file');
  parser.addFlag('binding', help: 'Generate Binding file');

  final results = parser.parse(arguments);

  if (results['controller']) {
    CreateController().createController();
  } else if (results['init']) {
    InitFolders().initFolders();
  } else if (results['view']) {
    CreateView().createView();
  } else if (results['binding']) {
    CreateBinding().createBinding();
  } else {
    print("Please enter a valid command");
  }
}
