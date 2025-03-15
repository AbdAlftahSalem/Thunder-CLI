import 'package:args/args.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/convert_api_collection_to_code.dart';
import 'package:thunder_cli/features/create_api_model/create_api_model.dart';
import 'package:thunder_cli/features/create_feature/create_feature.dart';
import 'package:thunder_cli/features/init_project/init_project.dart';
import 'package:thunder_cli/features/localization_feature/localization_feature.dart';

class GetCommand {
  static void getCommand(ArgResults results, ArgParser parser) async {
    if (results['init']) {
      // Initialize the project -> thunder --i
      await InitProject.initProject();
    } else if (results['feature']) {
      // Generate Feature -> thunder --m
      await CreateFeatureFiles.createFiles();
    } else if (results['model']) {
      // Generate model file for the module -> thunder --model
      await CreateApiModel.createApiModel();
    } else if (results['localization']) {
      // Generate locales file and auto translated words in application -> thunder --localization
      await LocalizationFeature.localizationFeature();
    } else if (results['c_api']) {
      // convert api collection to code
      await ConvertApiCollectionToCode.convertApiCollectionToCode();
    } else {
      _showHelpMessage();
    }
  }

  /// Show help message -> thunder --h
  static void _showHelpMessage() {
    String message = "⚡ Welcome to Thunder CLI 🚀🚀\n";
    message +=
        "⚡ Thunder CLI is a tool to create flutter project and auto generate files and folders\n\n";

    message += "⚡ Available commands: ";
    message += "1 - thunder --i : Initialize flutter project.";
    message +=
        "2 - thunder --feature : Create a new feature and handle UI , controllers , repos , DI and routing.";
    message +=
        "3 - thunder --model : create a new API model with API automatically.";
    message +=
        "4 - thunder --c_api : Convert API collection to coe with build repos and controllers .";
    message +=
        "5 - thunder --localization : Generate locales file and auto translated words in application";
    message += "6 - thunder --help : Show help message.";

    print(message);
  }
}
