import 'package:args/args.dart';
import 'package:thunder_cli/core/helper/services/command_service/get_command.dart';

class CommandServices {
  /// SetUp Commands to using ThunderCLI
  static startCommands(List<String> arguments) {
    final parser = ArgParser();

    // Add flags to the argument parser
    parser
      ..addFlag('i', help: 'Initialize project Thunder CMD')
      ..addFlag('m',
          help:
              'Generate all feature folder and files . [ View , Controller , and routing folder and files ]')
      ..addFlag('mm',
          help:
              'Generate all feature folder and files . [ View , Controller , model and routing folder and files ]')
      ..addFlag('mo', help: 'Generate model file for the feature')
      ..addFlag('h', help: 'Show help message');

    final results = parser.parse(arguments);

    GetCommand.getCommand(results, parser);
  }
}
