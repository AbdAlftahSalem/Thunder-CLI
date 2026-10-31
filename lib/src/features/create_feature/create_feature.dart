import '../../core/consts/state_management.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/services/format_service/format_service.dart';
import '../../core/services/console_service/console.dart';
import '../../core/services/project_service/project_service.dart';
import '../routes_feature/route_feature.dart';
import 'setup_feature_files.dart';

/// `thunder feature <name>`: view + controller + repository + binding + route.
class CreateFeatureFiles {
  /// Validates a feature name. Returns an error message or `null`.
  static String? validateName(String name) {
    if (name.trim().isEmpty) return 'Feature name cannot be empty !!';
    if (name.words.isEmpty) return 'Feature name must contain letters';
    if (RegExp(r'^[0-9]').hasMatch(name.toSnakeCase())) {
      return 'Feature name cannot start with a number';
    }
    return null;
  }

  /// Creates the feature. Asks for the name when [featureName] is null.
  static Future<int> createFiles(
      {String? featureName, bool force = false}) async {
    final project = ProjectService.require();
    if (project == null) return 1;

    final String name;
    try {
      name = Console.valueOrAsk(featureName, 'Enter your feature name',
          validate: validateName);
    } on ArgumentError catch (e) {
      Console.error('${e.message}');
      return 64;
    }
    await generate(project, name.toSnakeCase(), force: force);
    return 0;
  }

  /// Generates every file of the feature inside [project].
  static Future<void> generate(ProjectService project, String featureName,
      {bool force = false, bool quiet = false}) async {
    if (!quiet) {
      Console.info(
          "\n******************** $featureName (${project.stateManagement.label}) ********************\n");
    }

    await SetupFeatureFiles.setupFeatureFiles(project, featureName,
        force: force, quiet: quiet);

    await RouteFeature.setRoutes(project, featureName);
    await FormatService.format(project, RouteFeature.files(project));
    if (!quiet) {
      Console.success(
          "Add '/$featureName' to ${RouteFeature.files(project).map((f) => f.split('/').last).join(' and ')}");
      Console.info("\n⚡ Setup '$featureName' successfully 🎉");
      final route = 'Routes.${featureName.toConstantCase()}';
      Console.info(project.stateManagement == StateManagement.getx
          ? '   Open it with: Get.toNamed($route)\n'
          : '   Open it with: context.push($route)\n');
    }
  }
}
