import 'package:args/args.dart';
import 'package:thunder_cli/core/helper/services/command_service/get_command.dart';

class CommandServices {
  /// SetUp Commands to using ThunderCLI
  static startCommands(List<String> arguments) {
    final parser = ArgParser();

    // Add flags to the argument parser
    parser
      ..addFlag('init', help: 'Initialize project Thunder CMD')
      ..addFlag('feature',
          help:
              'Generate all feature folder and files . [ View , Controller , and routing folder and files ]')
      ..addFlag('model', help: 'Generate model file for the feature')
      ..addFlag('help', help: 'Show help message');

    final results = parser.parse(arguments);

    GetCommand.getCommand(results, parser);
  }
}
