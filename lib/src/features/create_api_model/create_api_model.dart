import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import '../../core/consts/folder_paths.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/networking/dio_handler.dart';
import '../../core/services/console_service/console.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';
import '../../core/services/format_service/format_service.dart';
import '../../core/services/project_service/project_service.dart';
import 'model_generator.dart';

/// `thunder model`: builds a model class from an API response (URL) or from
/// a JSON file.
class CreateApiModel {
  /// Runs the command. Returns the process exit code.
  static Future<int> createApiModel(ArgResults args) async {
    final project = ProjectService.require();
    if (project == null) return 1;

    final rest = args.rest;
    final String name;
    dynamic json;
    try {
      name = Console.valueOrAsk(
        (args['name'] as String?) ?? (rest.isNotEmpty ? rest.first : null),
        "Enter your model name [ thunder adds the 'Model' suffix ]",
        validate: (v) =>
            v.words.isEmpty ? 'Model name cannot be empty !!' : null,
      );
      final jsonFile = args['json'] as String?;
      if (jsonFile != null) {
        final file = File(jsonFile);
        if (!file.existsSync()) throw Exception('File not found: $jsonFile');
        json = jsonDecode(file.readAsStringSync());
      } else {
        json = await _fetch(args);
      }
    } on FormatException catch (e) {
      Console.error('Not valid JSON: ${e.message}');
      return 1;
    } on ArgumentError catch (e) {
      Console.error('${e.message}');
      return 64;
    } catch (e) {
      Console.error('$e'.replaceFirst('Exception: ', ''));
      return 1;
    }

    final String code;
    try {
      code = ModelGenerator.generate(name, json);
    } on ArgumentError catch (e) {
      Console.error('${e.message}');
      return 1;
    }

    final path = FolderPaths.instance.modelFile(
        name.replaceAll(RegExp(r'_?model$', caseSensitive: false), ''));
    if (FolderAndFileService.exists(project.path(path)) &&
        !(args['force'] as bool)) {
      Console.error('$path already exists (use --force to overwrite)');
      return 1;
    }
    await FolderAndFileService.createFile(project.path(path), code);
    await FormatService.format(project, [path]);
    Console.success('Create $path');
    return 0;
  }

  static Future<dynamic> _fetch(ArgResults args) async {
    final urlGiven = args['url'] as String?;
    final url = Console.valueOrAsk(
      urlGiven,
      'Enter your full url',
      validate: (v) => Uri.tryParse(v)?.hasScheme == true
          ? null
          : 'Enter a full url (https://...) or use --json <file>',
    );
    final methodText = (args['method'] as String?) ??
        (urlGiven != null
            ? 'get'
            : Console.ask(
                'Enter type of request [ get / post / put / patch / delete ]',
                defaultValue: 'get'));
    final method = RequestType.tryParse(methodText);
    if (method == null) {
      throw Exception(
          '"$methodText" is not one of get / post / put / patch / delete');
    }

    final body =
        _jsonOption(args, 'body', 'Enter your request body (JSON, optional)');
    final headers = _jsonOption(
        args, 'headers', 'Enter your request headers (JSON, optional)');

    Console.info('🔃 Calling $url ...');
    return DioHandler.request(
      url,
      method,
      body: body,
      headers: headers is Map ? Map<String, dynamic>.from(headers) : null,
    );
  }

  static dynamic _jsonOption(ArgResults args, String option, String question) {
    final text = (args[option] as String?) ??
        (args.wasParsed('url') ? '' : Console.ask(question));
    if (text.trim().isEmpty) return null;
    return jsonDecode(text);
  }
}
