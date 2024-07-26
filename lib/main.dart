import 'package:thunder_cli/core/models/request_model.dart';

import 'core/helper/services/command_service/command_service.dart';
import 'features/create_api_model/build_model_file.dart';
import 'features/create_feature/create_feature.dart';
import 'features/create_feature/setup_feature_files.dart';

void main(List<String> arguments) {
  // CommandServices.startCommands(arguments);
  // CreateFeatureFiles().createFiles();
  BuildModelFile.buildModelFile(requestModel: RequestModel(featureName: "home", modelName: 'home_new'), data: {"name" : "abd", "age" : 23});
}
