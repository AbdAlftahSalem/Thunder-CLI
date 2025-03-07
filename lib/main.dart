import 'package:thunder_cli/features/create_feature/create_feature.dart';

import 'core/services/command_service/command_service.dart';

void main(List<String> arguments) async {
  CreateFeatureFiles.createFiles();
  // CommandServices.startCommands(arguments);
}
