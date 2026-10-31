/// Edits generated Dart files (routes, bindings, API constants) without
/// rewriting the parts the developer changed by hand.
///
/// Thunder writes marker comments such as `// thunder:imports` into the files
/// it creates. New code is inserted right above the marker. When a marker is
/// missing (older projects, or the developer removed it) a safe fallback is
/// used and the marker is added back.
class CodeEditor {
  /// Adds [importLine] if the file does not already contain it.
  static String addImport(String content, String importLine) {
    if (content.contains(importLine)) return content;
    const marker = '// thunder:imports';
    if (content.contains(marker)) {
      return content.replaceFirst(marker, '$importLine\n$marker');
    }
    final imports = RegExp(r'^import .*;[ \t]*$', multiLine: true)
        .allMatches(content)
        .toList();
    if (imports.isEmpty) return '$importLine\n$content';
    final last = imports.last;
    return '${content.substring(0, last.end)}\n$importLine${content.substring(last.end)}';
  }

  /// Inserts [line] above `// thunder:<marker>`.
  ///
  /// When the marker is missing, [line] is inserted before the closing
  /// [fallbackClosing] (for example `];` or `}`) found last in the file (or
  /// right after [fallbackAfter] when it is given and found), and
  /// the marker is added so the next run finds it.
  ///
  /// Nothing changes when [alreadyThere] is found in the content.
  static String insertAtMarker(
    String content, {
    required String marker,
    required String line,
    required String alreadyThere,
    String fallbackClosing = '}',
    String? fallbackAfter,
    String indent = '    ',
  }) {
    if (content.contains(alreadyThere)) return content;
    final markerLine =
        RegExp('^([ \\t]*)// thunder:$marker\\s*\$', multiLine: true)
            .firstMatch(content);
    if (markerLine != null) {
      final ind = markerLine.group(1)!;
      return content.replaceRange(
          markerLine.start, markerLine.start, '$ind$line\n');
    }
    if (fallbackAfter != null && content.contains(fallbackAfter)) {
      final at = content.indexOf(fallbackAfter) + fallbackAfter.length;
      return '${content.substring(0, at)}\n$indent$line\n$indent// thunder:$marker${content.substring(at)}';
    }
    final index = content.lastIndexOf(fallbackClosing);
    if (index == -1) return '$content\n$line\n';
    return '${content.substring(0, index)}$indent$line\n$indent// thunder:$marker\n${content.substring(index)}';
  }
}
