import 'package:args/args.dart';

import './files_creator/create_controller.dart';
import './files_creator/init_folders.dart';

void main(List<String> arguments) {
  final parser = ArgParser();

  parser.addFlag('controller', help: 'Generate controller file');
  parser.addFlag('init', help: 'Initialize project with GetX and mvc');

  final results = parser.parse(arguments);

  if (results['controller']) {
    CreateController().createController();
  } else if (results['init']) {
    InitFolders().initFolders();
  }
}
