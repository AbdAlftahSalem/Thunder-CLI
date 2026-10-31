/// Thunder CLI: create Flutter projects with GetX + MVC and generate
/// features, models, API code and translations.
///
/// Most people use the `thunder` command (see the README). The generators
/// are also available as a library:
///
/// ```dart
/// import 'package:thunder_cli/thunder_cli.dart';
///
/// void main() {
///   print(ModelGenerator.generate('user', {'id': 1, 'name': 'Abd'}));
/// }
/// ```
library;

export 'src/core/consts/version.dart' show thunderVersion;
export 'src/core/extensions/string_extensions.dart' show StringConversion;
export 'src/core/services/command_service/command_service.dart'
    show CommandServices;
export 'src/features/convert_api_collection_to_code/api_code_generator.dart'
    show ApiCodeGenerator;
export 'src/features/convert_api_collection_to_code/models/request_model.dart'
    show RequestModel;
export 'src/features/convert_api_collection_to_code/postman_collection_parser.dart'
    show PostmanCollectionParser, ParsedCollection;
export 'src/features/create_api_model/model_generator.dart' show ModelGenerator;
export 'src/features/localization_feature/localization_files.dart'
    show LocalizationFiles;
