import 'package:args/args.dart';
import 'package:thunder_cli/core/helper/services/command_service/get_command.dart';

class CommandServices {
  static startCommands(List<String> arguments) {
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

    GetCommand.getCommand(results, parser);
  }
}
