import 'dart:convert';

import 'package:args/args.dart';

import '../../core/consts/folder_paths.dart';
import '../../core/services/console_service/console.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';
import '../../core/services/project_service/project_service.dart';
import 'localization_files.dart';
import 'translate_languages.dart';

/// `thunder localization`: translates every text in `strings_constants.dart`
/// and writes the GetX translation files.
///
/// Only texts that are not translated yet are sent to the translator, so the
/// command can be run again every time new texts are added.
class LocalizationFeature {
  static final _paths = FolderPaths.instance;

  /// Runs the command. Returns the process exit code.
  static Future<int> localizationFeature(ArgResults args,
      {Translate? translate}) async {
    final project = ProjectService.require();
    if (project == null) return 1;

    final settings = await _readSettings(project);
    final saved = (settings['localization'] as Map?) ?? {};

    final base = ((args['from'] as String?) ??
            saved['base_language'] as String? ??
            Console.ask('Enter base language code (ex: en)',
                defaultValue: 'en'))
        .trim();
    final toOption = (args['to'] as List<String>?) ?? const [];
    var targets = toOption.isNotEmpty
        ? toOption
        : ((saved['to_languages'] as List?)?.cast<String>() ??
            const <String>[]);
    if (targets.isEmpty) {
      targets = Console.ask(
              'Enter languages to translate to, separated by commas (ex: ar,fr)')
          .split(',');
    }
    targets = targets
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e != base)
        .toSet()
        .toList();
    if (base.isEmpty || targets.isEmpty) {
      Console.error(
          'Base language and at least one target language are required (ex: --from en --to ar)');
      return 64;
    }

    final stringsContent = await FolderAndFileService.readFile(
        project.path(_paths.stringConstantPath));
    final words = LocalizationFiles.readStringsConstants(stringsContent);
    if (words.isEmpty) {
      Console.error(
          'No texts found in ${_paths.stringConstantPath}. Add lines like:\n'
          '   static const String hello = "Hello";');
      return 1;
    }
    Console.success(
        'Thunder found ${words.length} texts in strings_constants.dart');

    // base language file: the texts themselves
    await _writeLanguage(project, base, words, words);

    translate ??= TranslateLanguages.translate;
    var failed = 0;
    for (final language in targets) {
      final path = project.path(_paths.translationFile(language));
      final existing = LocalizationFiles.readTranslationFile(
          await FolderAndFileService.readFile(path));
      final missing = {
        for (final e in words.entries)
          if (!existing.containsKey(e.key)) e.key: e.value,
      };
      final translated = <String, String>{...existing};
      if (missing.isNotEmpty) {
        Console.info(
            '🔃 Translating ${missing.length} texts to "$language" ...');
        final result =
            await translate(missing.values.toList(), from: base, to: language);
        var i = 0;
        for (final key in missing.keys) {
          final value = result[i++];
          if (value == null) {
            failed++;
          } else {
            translated[key] = value;
          }
        }
      }
      await _writeLanguage(project, language, words, translated);
      Console.success(
          '${_paths.translationFile(language)} (${translated.length}/${words.length} texts)');
    }

    final languages = [base, ...targets];
    final localContent =
        await FolderAndFileService.readFile(project.path(_paths.locale()));
    await FolderAndFileService.createFile(project.path(_paths.locale()),
        LocalizationFiles.localFile(languages, existing: localContent));

    settings['localization'] = {'base_language': base, 'to_languages': targets};
    await FolderAndFileService.createFile(project.path(_paths.thunderJsonFile),
        '${const JsonEncoder.withIndent('  ').convert(settings)}\n');

    if (failed > 0) {
      Console.warning(
          '$failed texts could not be translated (network?). Run the command again to retry them.');
    }
    Console.info(
        '\n⚡ Localization is ready 🎉  Use it with: Text(StringsConstants.home.tr)\n'
        '   Change language with: Get.updateLocale(const Locale(\'${targets.first}\'))\n');
    return failed > 0 ? 1 : 0;
  }

  static Future<void> _writeLanguage(ProjectService project, String language,
      Map<String, String> words, Map<String, String> translations) async {
    await FolderAndFileService.createFile(
      project.path(_paths.translationFile(language)),
      LocalizationFiles.translationFile(
          language, words.keys.toList(), translations),
    );
  }

  static Future<Map<String, dynamic>> _readSettings(
      ProjectService project) async {
    final text = await FolderAndFileService.readFile(
        project.path(_paths.thunderJsonFile));
    if (text.trim().isEmpty) return {};
    try {
      return Map<String, dynamic>.from(jsonDecode(text) as Map);
    } catch (_) {
      return {};
    }
  }
}
