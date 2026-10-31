import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

import '../../core/consts/bundled_templates.dart';
import '../../core/consts/state_management.dart';
import '../../core/services/cmd_service/run_in_cmd.dart';
import '../../core/services/console_service/console.dart';

/// Gets the files of the project template.
///
/// By default the template is downloaded from the
/// [Thunder-Template](https://github.com/AbdAlftahSalem/Thunder-Template)
/// repository (one branch per state management: `getx`, `bloc`, `cubit`).
/// A custom template can be a GitHub URL (`https://github.com/me/my_template#branch`),
/// any git URL, a `.zip` URL or a local folder. When the download fails, the
/// copy of the official template bundled with Thunder is used.
class TemplateSource {
  /// The official template repository.
  static const String defaultRepository =
      'https://github.com/AbdAlftahSalem/Thunder-Template';

  /// Returns a folder that contains the template (its `pubspec.yaml`, `lib/` ...).
  ///
  /// Throws an [Exception] when a custom [template] can not be fetched.
  static Future<Directory> fetch({
    required StateManagement state,
    required Directory workDir,
    String? template,
    bool offline = false,
  }) async {
    if (offline) return _bundled(state, workDir);

    if (template == null) {
      try {
        Console.step(
            'Downloading the ${state.label} template from $defaultRepository ...');
        return await _download(
            _githubZip(defaultRepository, state.name), workDir);
      } catch (e) {
        Console.warning(
            'Could not download the template (${_short(e)}). Using the copy bundled with Thunder.');
        return _bundled(state, workDir);
      }
    }

    final local = Directory(template);
    if (local.existsSync()) {
      Console.step('Using the template in ${local.path} ...');
      return local;
    }

    final hashIndex = template.indexOf('#');
    final url = hashIndex == -1 ? template : template.substring(0, hashIndex);
    final branch = hashIndex == -1 ? null : template.substring(hashIndex + 1);

    Console.step('Downloading the template from $template ...');
    if (url.endsWith('.zip')) return _download(url, workDir);
    final github = RegExp(
            r'^https?://github\.com/([^/]+)/([^/#?]+?)(?:\.git)?(?:/tree/([^#?]+))?/?$')
        .firstMatch(url);
    if (github != null) {
      final ref = branch ?? github.group(3) ?? 'HEAD';
      return _download(
          _githubZip('https://github.com/${github[1]}/${github[2]}', ref),
          workDir);
    }
    return _clone(url, branch, workDir);
  }

  static String _githubZip(String repository, String ref) =>
      '$repository/archive/$ref.zip';

  static Future<Directory> _download(String url, Directory workDir) async {
    final response = await Dio().get<List<int>>(
      url,
      options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(minutes: 2)),
    );
    final out = Directory(p.join(workDir.path, 'template'));
    // Files are written by hand (not extractFileToDisk) so the zip's
    // permissions can never make them unreadable.
    final archive = ZipDecoder().decodeBytes(response.data!);
    for (final entry in archive.files) {
      if (!entry.isFile) continue;
      final target = p.normalize(p.join(out.path, entry.name));
      if (!p.isWithin(out.path, target)) continue; // zip slip
      final file = File(target);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(entry.content);
    }
    return _templateRoot(out);
  }

  static Future<Directory> _clone(
      String url, String? branch, Directory workDir) async {
    final out = Directory(p.join(workDir.path, 'template'));
    final result = await RunInCmd.run('git', [
      'clone',
      '--depth',
      '1',
      if (branch != null) ...['--branch', branch],
      url,
      out.path,
    ]);
    if (result.exitCode != 0) throw Exception('git clone $url failed');
    return _templateRoot(out);
  }

  /// GitHub zips put everything in one top folder (`Repo-branch/`).
  static Directory _templateRoot(Directory dir) {
    if (File(p.join(dir.path, 'pubspec.yaml')).existsSync()) return dir;
    final children = dir.listSync().whereType<Directory>().toList();
    for (final child in children) {
      if (File(p.join(child.path, 'pubspec.yaml')).existsSync()) return child;
    }
    throw Exception('The template has no pubspec.yaml');
  }

  static Future<Directory> _bundled(
      StateManagement state, Directory workDir) async {
    final out = Directory(p.join(workDir.path, 'bundled_${state.name}'));
    for (final entry in bundledTemplates[state.name]!.entries) {
      final file = File(p.join(out.path, entry.key));
      await file.parent.create(recursive: true);
      await file.writeAsString(entry.value);
    }
    return out;
  }

  static String _short(Object e) {
    final text = e.toString().replaceFirst('Exception: ', '');
    return text.length > 120 ? '${text.substring(0, 120)}...' : text;
  }
}
