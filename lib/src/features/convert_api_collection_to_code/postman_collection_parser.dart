import 'dart:convert';

import '../../core/extensions/string_extensions.dart';
import '../../core/networking/dio_handler.dart';
import 'models/request_model.dart';
import 'models/variable_model.dart';

/// Result of reading a Postman collection.
class ParsedCollection {
  /// Base URL found in the collection (`null` when none was found).
  final String? baseUrl;

  /// Every request, in collection order.
  final List<RequestModel> requests;

  /// Variables defined in the collection.
  final List<VariableModel> variables;

  /// Creates the result.
  ParsedCollection(this.baseUrl, this.requests, this.variables);
}

/// Reads a Postman collection (v2.0 / v2.1 JSON export).
class PostmanCollectionParser {
  /// Parses [collection] (the decoded JSON of the exported file).
  static ParsedCollection parse(Map<String, dynamic> collection) {
    final variables = <VariableModel>[
      for (final v in (collection['variable'] as List? ?? const []))
        if (v is Map) VariableModel.fromMap(Map<String, dynamic>.from(v)),
    ];

    final raw = <_RawRequest>[];
    for (final item in (collection['item'] as List? ?? const [])) {
      if (item is! Map) continue;
      if (item['item'] is List) {
        _collect(
            item['item'] as List, item['name']?.toString() ?? 'general', raw);
      } else {
        _collect([item], 'general', raw);
      }
    }

    // The base URL is the most used `{{variable}}` at the start of the URLs.
    final counts = <String, int>{};
    for (final r in raw) {
      final m = RegExp(r'^\{\{\s*([^{}]+?)\s*\}\}').firstMatch(r.url);
      if (m != null) counts[m[1]!] = (counts[m[1]!] ?? 0) + 1;
    }
    String? baseVariable;
    if (counts.isNotEmpty) {
      baseVariable = (counts.entries.toList()
            ..sort((a, b) => b.value - a.value))
          .first
          .key;
    }
    String? baseUrl;
    if (baseVariable != null) {
      final value = variables
          .where((v) => v.key.toLowerCase() == baseVariable!.toLowerCase())
          .map((v) => v.value)
          .firstOrNull;
      if (value != null && value.isNotEmpty) baseUrl = value.updateSlashInUrl();
    }

    final usedNames = <String, Set<String>>{};
    final requests = <RequestModel>[];
    for (final r in raw) {
      var url = r.url.split('?').first.trim();
      String path;
      final baseMatch = baseVariable == null
          ? null
          : RegExp('^\\{\\{\\s*${RegExp.escape(baseVariable)}\\s*\\}\\}')
              .firstMatch(url);
      if (baseMatch != null) {
        path = url.substring(baseMatch.end);
      } else {
        // a full URL or another variable: substitute the known variables
        path = url.convertVariableToValue(variables);
        if (baseUrl != null && path.startsWith(baseUrl)) {
          path = path.substring(baseUrl.length);
        }
      }
      if (!path.startsWith('http')) {
        path = path.replaceFirst(RegExp(r'^/+'), '');
      }

      final pathParams = <String>[];
      path = path.replaceAllMapped(RegExp(r'(?<=/|^):([A-Za-z_][A-Za-z0-9_]*)'),
          (m) {
        pathParams.add(m[1]!);
        return '{${m[1]}}';
      });
      path = path.replaceAllMapped(RegExp(r'\{\{\s*([^{}]+?)\s*\}\}'), (m) {
        pathParams.add(m[1]!);
        return '{${m[1]}}';
      });

      final group =
          r.group.toSnakeCase().isEmpty ? 'general' : r.group.toSnakeCase();
      var name = r.name.toSnakeCase();
      if (name.isEmpty || RegExp(r'^[0-9]').hasMatch(name)) {
        name = 'request_$name';
      }
      final names = usedNames.putIfAbsent(group, () => {});
      final original = name;
      var i = 2;
      while (names.contains(name)) {
        name = '${original}_${i++}';
      }
      names.add(name);

      requests.add(RequestModel(
        name: name,
        group: group,
        requestType: RequestType.tryParse(r.method) ?? RequestType.get,
        path: path,
        pathParams: pathParams.toSet().toList(),
        queryParams: r.query,
        body: _decodeBody(r.body, variables),
        isFormData: r.body?['mode'] == 'formdata',
        responseExample: _firstJsonResponse(r.responses),
      ));
    }
    return ParsedCollection(baseUrl, requests, variables);
  }

  static void _collect(List items, String group, List<_RawRequest> out) {
    for (final item in items) {
      if (item is! Map) continue;
      if (item['item'] is List) {
        _collect(item['item'] as List, group, out);
        continue;
      }
      final request = item['request'];
      if (request == null) continue;
      String url = '';
      String method = 'GET';
      Map? body;
      final query = <String>[];
      if (request is String) {
        url = request;
      } else if (request is Map) {
        method = request['method']?.toString() ?? 'GET';
        final u = request['url'];
        if (u is String) {
          url = u;
        } else if (u is Map) {
          url = u['raw']?.toString() ?? '';
          for (final q in (u['query'] as List? ?? const [])) {
            if (q is Map && q['disabled'] != true && q['key'] != null) {
              query.add(q['key'].toString());
            }
          }
        }
        if (request['body'] is Map) body = request['body'] as Map;
      }
      if (query.isEmpty && url.contains('?')) {
        query.addAll(Uri.splitQueryString(url.split('?').last).keys);
      }
      out.add(_RawRequest(
        name: item['name']?.toString() ?? 'request',
        group: group,
        method: method,
        url: url,
        body: body,
        query: query,
        responses:
            item['response'] is List ? item['response'] as List : const [],
      ));
    }
  }

  static dynamic _decodeBody(Map? body, List<VariableModel> variables) {
    if (body == null) return null;
    switch (body['mode']) {
      case 'raw':
        final text = (body['raw'] ?? '')
            .toString()
            .convertVariableToValue(variables)
            .trim();
        if (text.isEmpty) return null;
        try {
          return jsonDecode(text);
        } catch (_) {
          return null;
        }
      case 'urlencoded':
      case 'formdata':
        final map = <String, dynamic>{};
        for (final field in (body[body['mode']] as List? ?? const [])) {
          if (field is! Map ||
              field['disabled'] == true ||
              field['key'] == null) {
            continue;
          }
          map[field['key'].toString()] = field['type'] == 'file'
              ? null
              : (field['value'] ?? '')
                  .toString()
                  .convertVariableToValue(variables);
        }
        return map.isEmpty ? null : map;
      default:
        return null;
    }
  }

  static dynamic _firstJsonResponse(List responses) {
    for (final response in responses) {
      if (response is! Map) continue;
      final text = response['body']?.toString() ?? '';
      if (text.trim().isEmpty) continue;
      try {
        final json = jsonDecode(text);
        if (json is Map || (json is List && json.any((e) => e is Map))) {
          return json;
        }
      } catch (_) {}
    }
    return null;
  }
}

class _RawRequest {
  final String name, group, method, url;
  final Map? body;
  final List<String> query;
  final List responses;

  _RawRequest({
    required this.name,
    required this.group,
    required this.method,
    required this.url,
    required this.body,
    required this.query,
    required this.responses,
  });
}
