import 'package:thunder_cli/core/services/command_service/command_service.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/convert_api_collection_to_code.dart';

void main(List<String> arguments) async {
  // CommandServices.startCommands(arguments);

  ConvertApiCollectionToCode.convertApiCollectionToCode();
}
