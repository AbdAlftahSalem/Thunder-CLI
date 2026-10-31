import '../../core/extensions/string_extensions.dart';

/// Converts a JSON response into Dart model classes with a named constructor,
/// `fromJson` and `toJson`.
///
/// ```dart
/// final code = ModelGenerator.generate('post', {'id': 1, 'title': 'Hi'});
/// ```
///
/// * Nested objects become their own classes (`author` => `AuthorModel`).
/// * Lists of objects become `List<XModel>`, keys of every element are merged.
/// * Numbers are read safely (`(json['x'] as num?)?.toInt()`), so an API that
///   sends `1` instead of `1.0` does not crash the app.
/// * Keys that are not valid Dart names (`first-name`, `class`, `2fa`) are
///   renamed (`firstName`, `classValue`, `field2fa`).
class ModelGenerator {
  /// Generates the code of the model called [name] from [json] (a Map, or a
  /// List whose elements are Maps). Every class gets the `Model` suffix.
  static String generate(String name, dynamic json) {
    final root = _objectFrom(json);
    if (root == null) {
      throw ArgumentError(
          'Thunder can convert only a JSON object or a list of objects');
    }
    final generator = _Generator();
    generator.addClass(
        name.replaceAll(RegExp(r'_?model$', caseSensitive: false), ''), root);
    return generator.output();
  }

  /// Returns the object to model: the map itself, or all the maps of a list
  /// merged together.
  static Map<String, dynamic>? _objectFrom(dynamic json) {
    if (json is Map) return Map<String, dynamic>.from(json);
    if (json is List) return _mergeMaps(json);
    return null;
  }

  static Map<String, dynamic>? _mergeMaps(List list) {
    final maps = list.whereType<Map>().toList();
    if (maps.isEmpty) return null;
    final merged = <String, dynamic>{};
    for (final map in maps) {
      map.forEach((key, value) {
        final k = key.toString();
        if (!merged.containsKey(k) || merged[k] == null) {
          merged[k] = value;
        } else if (merged[k] is int && value is double) {
          merged[k] = value;
        } else if (merged[k] is Map && value is Map) {
          merged[k] = {...value, ...merged[k] as Map};
        } else if (merged[k] is List && value is List) {
          merged[k] = [...merged[k] as List, ...value];
        }
      });
    }
    return merged;
  }
}

class _Field {
  final String key;
  final String name;
  final String type;
  final String fromJson;
  final String toJson;

  _Field(this.key, this.name, this.type, this.fromJson, this.toJson);
}

class _Generator {
  final List<String> _classes = [];
  final Set<String> _usedClassNames = {};

  String output() => _classes.join('\n');

  String _uniqueClassName(String base, String parent) {
    var name = '${base.toDartClassName()}Model';
    if (_usedClassNames.contains(name)) {
      name = '${parent.toDartClassName()}${base.toDartClassName()}Model';
    }
    var i = 2;
    final original = name;
    while (_usedClassNames.contains(name)) {
      name = original.replaceFirst(RegExp(r'Model$'), '${i++}Model');
    }
    _usedClassNames.add(name);
    return name;
  }

  String addClass(String name, Map<String, dynamic> data,
      {String parent = ''}) {
    final className = _uniqueClassName(name, parent);
    final index = _classes.length;
    _classes.add(''); // reserve the position so parents come first

    final fields = <_Field>[];
    final usedNames = <String>{};
    data.forEach((key, value) {
      var fieldName = key.toDartIdentifier();
      var i = 2;
      final original = fieldName;
      while (usedNames.contains(fieldName)) {
        fieldName = '$original${i++}';
      }
      usedNames.add(fieldName);
      fields.add(_field(key, fieldName, value, name));
    });

    final b = StringBuffer();
    b.writeln('class $className {');
    for (final f in fields) {
      b.writeln('  ${f.type} ${f.name};');
    }
    b.writeln();
    if (fields.isEmpty) {
      b.writeln('  $className();');
    } else {
      b.writeln('  $className({');
      for (final f in fields) {
        b.writeln('    this.${f.name},');
      }
      b.writeln('  });');
    }
    b.writeln();
    b.writeln('  factory $className.fromJson(Map<String, dynamic> json) {');
    if (fields.isEmpty) {
      b.writeln('    return $className();');
    } else {
      b.writeln('    return $className(');
      for (final f in fields) {
        b.writeln('      ${f.name}: ${f.fromJson},');
      }
      b.writeln('    );');
    }
    b.writeln('  }');
    b.writeln();
    b.writeln('  Map<String, dynamic> toJson() {');
    b.writeln('    final Map<String, dynamic> data = <String, dynamic>{};');
    for (final f in fields) {
      b.writeln("    data['${f.key.escapeForDartString()}'] = ${f.toJson};");
    }
    b.writeln('    return data;');
    b.writeln('  }');
    b.writeln('}');
    _classes[index] = b.toString();
    return className;
  }

  _Field _field(String key, String name, dynamic value, String parent) {
    final j = "json['${key.escapeForDartString()}']";
    if (value is bool) return _Field(key, name, 'bool?', j, name);
    if (value is int) {
      return _Field(key, name, 'int?', '($j as num?)?.toInt()', name);
    }
    if (value is double) {
      return _Field(key, name, 'double?', '($j as num?)?.toDouble()', name);
    }
    if (value is String) {
      return _Field(key, name, 'String?', '$j?.toString()', name);
    }
    if (value is Map) {
      final cls =
          addClass(key, Map<String, dynamic>.from(value), parent: parent);
      return _Field(
          key,
          name,
          '$cls?',
          '$j is Map<String, dynamic> ? $cls.fromJson($j) : null',
          '$name?.toJson()');
    }
    if (value is List) {
      final maps = value.whereType<Map>().toList();
      if (maps.isNotEmpty) {
        final merged = ModelGenerator._mergeMaps(maps)!;
        final cls = addClass(key, merged, parent: parent);
        return _Field(
          key,
          name,
          'List<$cls>?',
          '$j is List ? ($j as List).whereType<Map<String, dynamic>>().map($cls.fromJson).toList() : null',
          '$name?.map((e) => e.toJson()).toList()',
        );
      }
      final itemType = _primitiveListType(value);
      if (itemType == 'dynamic') {
        return _Field(key, name, 'List<dynamic>?',
            '$j is List ? List<dynamic>.from($j) : null', name);
      }
      final convert = switch (itemType) {
        'int' => '(e as num).toInt()',
        'double' => '(e as num).toDouble()',
        'String' => 'e.toString()',
        _ => 'e as bool',
      };
      return _Field(
          key,
          name,
          'List<$itemType>?',
          '$j is List ? ($j as List).where((e) => e != null).map((e) => $convert).toList() : null',
          name);
    }
    return _Field(key, name, 'dynamic', j, name);
  }

  String _primitiveListType(List list) {
    final items = list.where((e) => e != null).toList();
    if (items.isEmpty) return 'dynamic';
    if (items.every((e) => e is int)) return 'int';
    if (items.every((e) => e is num)) return 'double';
    if (items.every((e) => e is String)) return 'String';
    if (items.every((e) => e is bool)) return 'bool';
    return 'dynamic';
  }
}
