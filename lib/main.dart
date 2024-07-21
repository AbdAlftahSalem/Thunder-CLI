import 'core/helper/services/command_service/command_service.dart';
import 'features/create_feature/create_feature.dart';
import 'features/create_feature/setup_feature_files.dart';

void main(List<String> arguments) {
  // CommandServices.startCommands(arguments);
  CreateFeatureFiles().createFiles();
}
