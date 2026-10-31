import 'dart:io';

import 'package:thunder_cli/thunder_cli.dart';

Future<void> main(List<String> arguments) async {
  exitCode = await CommandServices.startCommands(arguments);
}
