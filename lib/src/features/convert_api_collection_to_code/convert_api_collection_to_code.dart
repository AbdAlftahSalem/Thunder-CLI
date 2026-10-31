import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import '../../core/consts/folder_paths.dart';
import '../../core/consts/state_management.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/services/console_service/console.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';
import '../../core/services/format_service/format_service.dart';
import '../../core/services/project_service/project_service.dart';
import '../create_feature/setup_feature_files.dart';
import 'api_code_generator.dart';
import 'models/request_model.dart';
import 'postman_collection_parser.dart';

/// `thunder c_api`: converts a Postman collection to code.
///
/// 1. Adds every route to `api_constants.dart` (and the base URL).
/// 2. Builds a body model for every request with a JSON body.
/// 3. Builds a response model for every request with a saved JSON example.
/// 4. Builds one repository per folder of the collection.
/// 5. Builds one controller (GetX), bloc (BLoC) or cubit (Cubit) per folder
///    and registers it with the repository for dependency injection.
class ConvertApiCollectionToCode {
  static final _paths = FolderPaths.instance;
  static final List<String> _written = [];

  /// Runs the command. Returns the process exit code.
  static Future<int> convertApiCollectionToCode(ArgResults args) async {
    final project = ProjectService.require();
    if (project == null) return 1;
    final force = args['force'] as bool;

    final rest = args.rest;
    final String path;
    try {
      path = Console.valueOrAsk(
        (args['collection'] as String?) ??
            (rest.isNotEmpty ? rest.first : null),
        'Enter the path of your Postman collection (.json)',
        validate: (v) => File(v).existsSync() ? null : 'File not found: "$v"',
      );
    } on ArgumentError catch (e) {
      Console.error('${e.message}');
      return 64;
    }

    final Map<String, dynamic> collection;
    try {
      final decoded = jsonDecode(File(path).readAsStringSync());
      if (decoded is! Map<String, dynamic> || decoded['item'] is! List) {
        throw const FormatException(
            'this is not a Postman collection (no "item" list)');
      }
      collection = decoded;
    } on FormatException catch (e) {
      Console.error('Could not read the collection: ${e.message}');
      return 1;
    }

    final parsed = PostmanCollectionParser.parse(collection);
    if (parsed.requests.isEmpty) {
      Console.error('No requests found in the collection');
      return 1;
    }
    final style = project.stateManagement;
    Console.success(
        'Read ${parsed.variables.length} variables and ${parsed.requests.length} requests (${style.label} project)');

    // 1- routes in api_constants.dart
    await _writeConstants(project, parsed);
    Console.success(
        'Add ${parsed.requests.length} routes to api_constants.dart');

    final groups = <String, List<RequestModel>>{};
    for (final r in parsed.requests) {
      groups.putIfAbsent(r.group, () => []).add(r);
    }

    // 2, 3- models
    var models = 0;
    for (final r in parsed.requests) {
      final body = ApiCodeGenerator.bodyModel(r);
      if (body != null &&
          await _write(
              project,
              '${_paths.modelsFolder}/${ApiCodeGenerator.bodyModelFile(r)}',
              body,
              force)) {
        models++;
      }
      final response = ApiCodeGenerator.responseModel(r);
      if (response != null &&
          await _write(
              project,
              '${_paths.modelsFolder}/${ApiCodeGenerator.responseModelFile(r)}',
              response,
              force)) {
        models++;
      }
    }
    Console.success('Build $models models');

    // 4, 5- repositories + controllers / blocs / cubits
    final pkg = project.packageName;
    for (final entry in groups.entries) {
      final group = entry.key;
      final requests = entry.value;
      await _write(project, _paths.repoFile(group),
          ApiCodeGenerator.repo(group, requests, pkg), force);
      switch (style) {
        case StateManagement.getx:
          await _write(project, _paths.controllerFile(group),
              ApiCodeGenerator.controller(group, requests, pkg), force);
        case StateManagement.bloc:
          await _write(project, _paths.blocFile(group),
              ApiCodeGenerator.bloc(group, requests, pkg), force);
          await _write(project, _paths.eventFile(group),
              ApiCodeGenerator.blocEvents(group, requests), force);
          await _write(project, _paths.stateFile(group, cubit: false),
              ApiCodeGenerator.blocState(group, requests, cubit: false), force);
        case StateManagement.cubit:
          await _write(project, _paths.cubitFile(group),
              ApiCodeGenerator.cubit(group, requests, pkg), force);
          await _write(project, _paths.stateFile(group, cubit: true),
              ApiCodeGenerator.blocState(group, requests, cubit: true), force);
      }
      await SetupFeatureFiles.bindings(project, group);
    }
    final kind = switch (style) {
      StateManagement.getx => 'controllers',
      StateManagement.bloc => 'blocs',
      StateManagement.cubit => 'cubits',
    };
    Console.success(
        'Build ${groups.length} repositories and $kind: ${groups.keys.join(', ')}');
    await FormatService.format(
        project, [..._written, _paths.apiConstRoutesFile]);
    _written.clear();

    Console.info('\n⚡ API collection converted successfully 🎉\n');
    for (final r in parsed.requests) {
      final target = switch (style) {
        StateManagement.getx =>
          '${r.group.toDartClassName()}Controller.${r.name.toDartIdentifier()}()',
        StateManagement.bloc =>
          '${r.group.toDartClassName()}Bloc ← ${r.name.toDartClassName()}Requested',
        StateManagement.cubit =>
          '${r.group.toDartClassName()}Cubit.${r.name.toDartIdentifier()}()',
      };
      Console.info(
          '   ${r.requestType.name.toUpperCase().padRight(6)} ${r.path}  →  $target');
    }
    return 0;
  }

  static Future<bool> _write(
      ProjectService project, String path, String content, bool force) async {
    final file = project.path(path);
    if (FolderAndFileService.exists(file) && !force) {
      Console.warning(
          '$path already exists, skipped (use --force to overwrite)');
      return false;
    }
    await FolderAndFileService.createFile(file, content);
    _written.add(path);
    return true;
  }

  static Future<void> _writeConstants(
      ProjectService project, ParsedCollection parsed) async {
    final file = project.path(_paths.apiConstRoutesFile);
    var content = await FolderAndFileService.readFile(file);
    if (parsed.baseUrl != null) {
      final url = parsed.baseUrl!.escapeForDartString();
      final env = RegExp(
          r"(static const (?:String )?baseUrl\s*=\s*String\.fromEnvironment\([^;]*?defaultValue:\s*)'[^']*'");
      final plain = RegExp(r'static const (?:String )?baseUrl\s*=[^;]*;');
      if (env.hasMatch(content)) {
        // keep --dart-define=BASE_URL working, only change the default value
        content = content.replaceFirstMapped(env, (m) => "${m[1]}'$url'");
      } else if (plain.hasMatch(content)) {
        content = content.replaceFirst(plain, "static const baseUrl = '$url';");
      } else if (content.isEmpty) {
        content =
            "class ApiConstants {\n  static const baseUrl = '$url';\n  // thunder:endpoints\n}\n";
      }
      await FolderAndFileService.createFile(file, content);
    }

    final taken = <String, String>{
      for (final m in RegExp(r"static const (?:String )?(\w+)\s*=\s*'([^']*)'")
          .allMatches(content))
        m[1]!: m[2]!,
    };
    for (final r in parsed.requests) {
      var name = r.name.toDartIdentifier();
      if (taken.containsKey(name) && taken[name] != r.path) {
        name = '${r.group}_${r.name}'.toDartIdentifier();
      }
      var i = 2;
      final original = name;
      while (taken.containsKey(name) && taken[name] != r.path) {
        name = '$original${i++}';
      }
      taken[name] = r.path;
      r.constantName = name;
      await SetupFeatureFiles.addEndpoint(project, name, r.path);
    }
  }
}
