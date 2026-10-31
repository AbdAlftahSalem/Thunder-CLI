import '../extensions/string_extensions.dart';

/// Where Thunder puts every generated file inside a Flutter project.
///
/// All paths are relative to the project root.
///
/// ```
/// lib/
/// ├── main.dart
/// ├── core/
/// │   ├── bindings/bindings_app.dart      (GetX dependency injection)
/// │   ├── di/injection.dart               (BLoC / Cubit: get_it)
/// │   ├── networking/                     (DioHelper, ApiResult, enums)
/// │   ├── routing/routes.dart, app_routes.dart (GetX) or app_router.dart (go_router)
/// │   └── theme/app_theme.dart
/// ├── helper/
/// │   ├── constants/api_constants.dart, strings_constants.dart
/// │   ├── translations/                   (GetX translations)
/// │   └── widgets/custom_widgets/custom_text.dart
/// └── app/
///     ├── features/<feature>/<feature>_view.dart + <feature>_controller.dart (GetX)
///     │                      or bloc/<feature>_bloc|event|state.dart, cubit/<feature>_cubit|state.dart
///     ├── repositories/<feature>_repo.dart
///     └── models/<name>_model.dart
/// ```
class FolderPaths {
  // create singleton for FolderPaths
  static final FolderPaths instance = FolderPaths._internal();

  factory FolderPaths() => instance;

  FolderPaths._internal();

  // core
  String bindingsFile = 'lib/core/bindings/bindings_app.dart';
  String diFile = 'lib/core/di/injection.dart';
  String appRouterFile = 'lib/core/routing/app_router.dart';
  String localizationServiceFile =
      'lib/core/services/localization_service.dart';
  String baseClientFile = 'lib/core/networking/base_client.dart';
  String apiResultFile = 'lib/core/networking/api_result.dart';
  String enumsNetworkingFile = 'lib/core/networking/enums_networking.dart';
  String appThemeFile = 'lib/core/theme/app_theme.dart';

  // routes files
  String appRoutesFile = 'lib/core/routing/app_routes.dart';
  String routesFile = 'lib/core/routing/routes.dart';

  // helper
  String apiConstRoutesFile = "lib/helper/constants/api_constants.dart";
  String stringConstantPath = "lib/helper/constants/strings_constants.dart";
  String customTextFile = 'lib/helper/widgets/custom_widgets/custom_text.dart';
  String translationsFolder = 'lib/helper/translations';

  // app
  String featureFolder = 'lib/app/features';
  String repoFolder = 'lib/app/repositories';
  String modelsFolder = 'lib/app/models';

  /// Thunder settings for the project (localization languages ...).
  String thunderJsonFile = 'thunder.json';

  /// Converts a project path (`lib/...`) to the path used in a
  /// `package:` import (without `lib/`).
  String libRelative(String path) =>
      path.startsWith('lib/') ? path.substring(4) : path;

  // feature files
  String featureDir(String name) => '$featureFolder/${name.toSnakeCase()}';

  String controllerFile(String name) =>
      '${featureDir(name)}/${name.toSnakeCase()}_controller.dart';

  String viewFile(String name) =>
      '${featureDir(name)}/${name.toSnakeCase()}_view.dart';

  String blocFile(String name) =>
      '${featureDir(name)}/bloc/${name.toSnakeCase()}_bloc.dart';

  String eventFile(String name) =>
      '${featureDir(name)}/bloc/${name.toSnakeCase()}_event.dart';

  String cubitFile(String name) =>
      '${featureDir(name)}/cubit/${name.toSnakeCase()}_cubit.dart';

  /// `bloc/<name>_state.dart` or `cubit/<name>_state.dart`.
  String stateFile(String name, {required bool cubit}) =>
      '${featureDir(name)}/${cubit ? 'cubit' : 'bloc'}/${name.toSnakeCase()}_state.dart';

  String repoFile(String name) => '$repoFolder/${name.toSnakeCase()}_repo.dart';

  String modelFile(String modelName) =>
      '$modelsFolder/${modelName.toSnakeCase()}_model.dart';

  String translationFile(String languageCode) =>
      '$translationsFolder/${languageCode.toSnakeCase()}_translation.dart';

  String locale() => "$translationsFolder/local.dart";
}
