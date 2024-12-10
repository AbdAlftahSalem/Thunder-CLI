import 'core/services/command_service/command_service.dart';
import './features/convert_api_collection_to_code/convert_api_collection_to_code.dart';

void main(List<String> arguments) async {
  // CommandServices.startCommands(arguments);
  ConvertApiCollectionToCode.convertApiCollectionToCode();
}
