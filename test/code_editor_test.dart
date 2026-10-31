import 'package:test/test.dart';
import 'package:thunder_cli/src/core/services/code_editor/code_editor.dart';

void main() {
  group('CodeEditor', () {
    const routes = '''
abstract class Routes {
  static const HOME = '/home';
  // thunder:routes
}
''';

    test('inserts above the marker and keeps it', () {
      final out = CodeEditor.insertAtMarker(routes,
          marker: 'routes',
          line: "static const PROFILE = '/profile';",
          alreadyThere: 'PROFILE ');
      expect(
          out,
          contains(
              "  static const PROFILE = '/profile';\n  // thunder:routes"));
    });

    test('is idempotent', () {
      final once = CodeEditor.insertAtMarker(routes,
          marker: 'routes',
          line: "static const HOME = '/home';",
          alreadyThere: 'static const HOME ');
      expect(once, routes);
    });

    test('falls back when the marker was removed', () {
      const bindings = '''
class BindingApp extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DioHelper());
  }
}
''';
      final out = CodeEditor.insertAtMarker(bindings,
          marker: 'bindings',
          line: 'Get.lazyPut(() => HomeRepo(Get.find<DioHelper>()));',
          alreadyThere: 'HomeRepo(',
          fallbackAfter: 'void dependencies() {');
      expect(
          out,
          contains(
              'void dependencies() {\n    Get.lazyPut(() => HomeRepo(Get.find<DioHelper>()));\n    // thunder:bindings'));
    });

    test('addImport adds once, after the last import', () {
      const content = "import 'a.dart';\n\nclass A {}\n";
      final out = CodeEditor.addImport(content, "import 'b.dart';");
      expect(out, "import 'a.dart';\nimport 'b.dart';\n\nclass A {}\n");
      expect(CodeEditor.addImport(out, "import 'b.dart';"), out);
    });
  });
}
