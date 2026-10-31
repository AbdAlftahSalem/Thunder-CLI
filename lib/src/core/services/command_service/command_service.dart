import 'package:args/args.dart';

import '../../consts/version.dart';
import '../../../features/convert_api_collection_to_code/convert_api_collection_to_code.dart';
import '../../../features/create_api_model/create_api_model.dart';
import '../../../features/create_feature/create_feature.dart';
import '../../../features/init_project/init_project.dart';
import '../../../features/localization_feature/localization_feature.dart';
import '../console_service/console.dart';

/// Parses the command line and runs the right command.
class CommandServices {
  /// Old flag style (`thunder --feature`) => command name.
  static const Map<String, String> legacyFlags = {
    '--init': 'init',
    '--i': 'init',
    '--feature': 'feature',
    '--m': 'feature',
    '--model': 'model',
    '--c_api': 'c_api',
    '--localization': 'localization',
    '--help': 'help',
    '--h': 'help',
    '-h': 'help',
    '--version': 'version',
    '-v': 'version',
  };

  /// Command aliases.
  static const Map<String, String> aliases = {
    'create': 'init',
    'api': 'c_api',
    'l10n': 'localization',
  };

  /// Builds the argument parser with every command and its options.
  static ArgParser buildParser() {
    final parser = ArgParser()
      ..addFlag('yes',
          abbr: 'y',
          negatable: false,
          help: 'Never ask questions: use the options and defaults.');

    parser.addCommand(
      'init',
      ArgParser()
        ..addOption('name',
            help:
                'Package name of the app (ex: my_app). Can also be the first argument.')
        ..addOption('org',
            help: 'Organization in reverse domain notation.',
            defaultsTo: null,
            valueHelp: 'com.example')
        ..addOption('title',
            help: 'App title shown to users (default: from the name).')
        ..addOption('path',
            help: 'Folder to create the project in (default: the name).')
        ..addMultiOption('platforms',
            help: 'Platforms for flutter create (default: all).',
            valueHelp: 'android,ios,web')
        ..addFlag('git',
            help: 'Create a git repository with a first commit.',
            defaultsTo: true)
        ..addOption('remote',
            help: 'GitHub repository URL to push the first commit to.')
        ..addFlag('github-action',
            help:
                'Add a GitHub Action that builds an APK and sends it to Telegram.')
        ..addFlag('vscode', help: 'Open the project in VS Code at the end.'),
    );
    parser.addCommand(
      'feature',
      ArgParser()
        ..addFlag('force',
            abbr: 'f', negatable: false, help: 'Overwrite existing files.'),
    );
    parser.addCommand(
      'model',
      ArgParser()
        ..addOption('name',
            help:
                'Model name (ex: post => PostModel). Can also be the first argument.')
        ..addOption('url', help: 'API url that returns the JSON.')
        ..addOption('method',
            help: 'HTTP method.',
            allowed: ['get', 'post', 'put', 'patch', 'delete'])
        ..addOption('body', help: 'Request body as JSON.')
        ..addOption('headers', help: 'Request headers as JSON.')
        ..addOption('json',
            help: 'Build the model from a local JSON file instead of a url.'),
    );
    parser.addCommand(
      'c_api',
      ArgParser()
        ..addOption('collection',
            abbr: 'c', help: 'Path of the Postman collection (.json).')
        ..addFlag('force',
            abbr: 'f', negatable: false, help: 'Overwrite existing files.'),
    );
    parser.addCommand(
      'localization',
      ArgParser()
        ..addOption('from', help: 'Base language code (ex: en).')
        ..addMultiOption('to', help: 'Languages to translate to (ex: ar,fr).'),
    );
    parser.addCommand('help');
    parser.addCommand('version');
    return parser;
  }

  /// Converts old style flags and aliases to the command form.
  static List<String> normalize(List<String> arguments) {
    final args = [...arguments];
    for (var i = 0; i < args.length; i++) {
      final arg = args[i];
      if (arg == '--yes' || arg == '-y') continue;
      if (legacyFlags.containsKey(arg)) {
        args[i] = legacyFlags[arg]!;
      } else if (aliases.containsKey(arg)) {
        args[i] = aliases[arg]!;
      }
      break;
    }
    return args;
  }

  /// Runs Thunder with [arguments]. Returns the process exit code.
  static Future<int> startCommands(List<String> arguments) async {
    final parser = buildParser();
    final ArgResults results;
    try {
      results = parser.parse(normalize(arguments));
    } on FormatException catch (e) {
      Console.error(e.message);
      Console.info('');
      Console.info(usage(parser));
      return 64;
    }

    Console.nonInteractive = results['yes'] as bool;
    final command = results.command;
    switch (command?.name) {
      case 'init':
        return InitProject.initProject(command!);
      case 'feature':
        return CreateFeatureFiles.createFiles(
          featureName: command!.rest.isEmpty ? null : command.rest.join('_'),
          force: command['force'] as bool,
        );
      case 'model':
        return CreateApiModel.createApiModel(command!);
      case 'c_api':
        return ConvertApiCollectionToCode.convertApiCollectionToCode(command!);
      case 'localization':
        return LocalizationFeature.localizationFeature(command!);
      case 'version':
        Console.info('Thunder CLI $thunderVersion');
        return 0;
      default:
        Console.info(usage(parser));
        return results.rest.isEmpty ? 0 : 64;
    }
  }

  /// The help message.
  static String usage(ArgParser parser) {
    String options(String name) => parser.commands[name]!.usage
        .split('\n')
        .map((line) => '      $line')
        .join('\n');
    return '''
⚡ Thunder CLI $thunderVersion — Flutter project generator (GetX + MVC)

Usage: thunder <command> [options]

Commands:
  init [name]          Create a new Flutter project with the Thunder structure.
${options('init')}

  feature <name>       Create a feature: view, controller, repository, binding and route.
${options('feature')}

  model [name]         Create a model (fromJson / toJson) from an API response or a JSON file.
${options('model')}

  c_api [collection]   Convert a Postman collection to API constants, models, repositories and controllers.
${options('c_api')}

  localization         Translate the texts in strings_constants.dart and set up GetX translations.
${options('localization')}

  help                 Show this message.
  version              Show the Thunder version.

Global options:
  -y, --yes            Never ask questions: use the options and defaults.

Examples:
  thunder init my_app --org com.company
  thunder feature profile
  thunder model --name post --url https://jsonplaceholder.typicode.com/posts
  thunder c_api --collection my_api.postman_collection.json
  thunder localization --from en --to ar,fr
''';
  }
}
