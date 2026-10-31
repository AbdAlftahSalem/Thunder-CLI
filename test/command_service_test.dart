import 'dart:io';

import 'package:test/test.dart';
import 'package:thunder_cli/thunder_cli.dart';

void main() {
  group('CommandServices', () {
    test('old flags still work', () {
      expect(CommandServices.normalize(['--init']), ['init']);
      expect(CommandServices.normalize(['--feature']), ['feature']);
      expect(CommandServices.normalize(['--c_api']), ['c_api']);
      expect(CommandServices.normalize(['--h']), ['help']);
      expect(CommandServices.normalize(['-y', '--model', '--name', 'x']),
          ['-y', 'model', '--name', 'x']);
      expect(CommandServices.normalize(['api', 'a.json']), ['c_api', 'a.json']);
    });

    test('every command is parsed', () {
      final parser = CommandServices.buildParser();
      for (final command in [
        'init',
        'feature',
        'model',
        'c_api',
        'localization',
        'help',
        'version'
      ]) {
        expect(parser.parse([command]).command?.name, command);
      }
    });

    test('help and version exit with 0', () async {
      expect(await CommandServices.startCommands(['--help']), 0);
      expect(await CommandServices.startCommands([]), 0);
      expect(await CommandServices.startCommands(['version']), 0);
    });

    test('unknown options exit with 64', () async {
      expect(await CommandServices.startCommands(['--nope']), 64);
    });

    test('thunderVersion matches pubspec.yaml', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(
          RegExp(r'^version:\s*(\S+)', multiLine: true)
              .firstMatch(pubspec)!
              .group(1),
          thunderVersion);
    });
  });
}
