import 'package:thunder_cli/core/helper/consts/folder_paths.dart';

import 'core/helper/services/command_service/command_service.dart';
import 'core/helper/services/folder_and_file_service/create_file.dart';
import 'features/create_feature/setup_feature_files.dart';

void main(List<String> arguments) {
  // CommandServices.startCommands(arguments);
  // SetupFeatureFiles.bindings("home");
  CreateFile.createFile(FolderPaths.instance.bindingsFile, "ABD");
}
