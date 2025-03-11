import 'package:thunder_cli/features/create_feature/create_feature.dart';

import 'core/services/command_service/command_service.dart';
import 'features/create_api_model/create_api_model.dart';

void main(List<String> arguments) async {
  CreateApiModel.createApiModel();
  // CreateFeatureFiles.createFiles();
  // CommandServices.startCommands(arguments);
}
