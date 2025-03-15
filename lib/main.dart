import 'package:thunder_cli/core/services/command_service/command_service.dart';
import 'package:thunder_cli/features/init_project/init_project.dart';

void main(List<String> arguments) async {
  // CommandServices.startCommands(arguments);
  await InitProject.initProject();

}
