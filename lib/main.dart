import 'core/services/command_service/command_service.dart';
import 'features/create_feature/create_feature.dart';
import 'features/localization_feature/localization_feature.dart';

void main(List<String> arguments) async{
  // CommandServices.startCommands(arguments);
  // await CreateFeatureFiles.createFiles();
  LocalizationFeature.localizationFeature();
}
