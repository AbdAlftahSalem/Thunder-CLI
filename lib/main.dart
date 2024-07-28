import 'package:thunder_cli/features/create_feature/create_feature.dart';

import 'core/helper/services/command_service/command_service.dart';
import 'core/helper/services/folder_and_file_service/folder_and_file_service.dart';
import 'features/create_api_model/setup_request_data.dart';

void main(List<String> arguments) {
  // CommandServices.startCommands(arguments);
  // SetupRequestData.setupRequestData();
  // FolderAndFileService.createFolder('lib/b1/b2/b3/b4');
  CreateFeatureFiles().createFiles();
}
