import 'dart:math';

import 'package:thunder_cli/core/models/variable_model.dart';

import 'core/services/command_service/command_service.dart';
import 'features/convert_api_collection_to_code/convert_api_collection_to_code.dart';
import 'features/create_api_model/create_api_model.dart';
import 'features/create_feature/create_feature.dart';

void main(List<String> arguments) {
  // CommandServices.startCommands(arguments);
  // CreateFeatureFiles().createFiles();

  CreateApiModel().createApiModel();

  // ConvertApiCollectionToCode.convertApiCollectionToCode();

}
