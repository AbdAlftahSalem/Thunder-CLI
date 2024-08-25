import 'dart:convert';

import 'core/services/command_service/command_service.dart';
import 'features/convert_api_collection_to_code/convert_api_collection_to_code.dart';

void main(List<String> arguments) {
  // CommandServices.startCommands(arguments);
  ConvertApiCollectionToCode.convertApiCollectionToCode();
  // Map<String , dynamic> s = {
  //   "mode": "raw",
  //   "raw": "{\r\n    \"instanceId\": \"AbdAlftah\"\r\n}",
  //   "options": {
  //     "raw": {
  //       "language": "json"
  //     }
  //   }
  // };
  // print(jsonDecode(s['raw']));
}
