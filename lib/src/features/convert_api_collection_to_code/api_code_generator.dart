import '../../core/extensions/string_extensions.dart';
import '../create_api_model/model_generator.dart';
import 'models/request_model.dart';

/// Builds the Dart code (models, repositories, controllers) for the requests
/// of a Postman collection.
class ApiCodeGenerator {
  /// Class name of the body model of [r] (`LoginBodyModel`).
  static String bodyModelClass(RequestModel r) =>
      '${'${r.name}_body'.toDartClassName()}Model';

  /// Class name of the response model of [r] (`LoginResponseModel`).
  static String responseModelClass(RequestModel r) =>
      '${'${r.name}_response'.toDartClassName()}Model';

  /// File name (in `lib/app/models/`) of the body model of [r].
  static String bodyModelFile(RequestModel r) => '${r.name}_body_model.dart';

  /// File name (in `lib/app/models/`) of the response model of [r].
  static String responseModelFile(RequestModel r) =>
      '${r.name}_response_model.dart';

  /// Code of the body model, or `null` when the request has no JSON object body.
  static String? bodyModel(RequestModel r) =>
      r.hasBodyModel ? ModelGenerator.generate('${r.name}_body', r.body) : null;

  /// Code of the response model, or `null` when the collection has no saved
  /// JSON example response for the request.
  static String? responseModel(RequestModel r) => r.responseExample == null
      ? null
      : ModelGenerator.generate('${r.name}_response', r.responseExample);

  /// `true` when the example response is a list (`List<XModel>`).
  static bool responseIsList(RequestModel r) => r.responseExample is List;

  /// Repository with one method per request of the group.
  static String repo(
      String group, List<RequestModel> requests, String packageName) {
    final className = '${group.toDartClassName()}Repo';
    final imports = <String>{
      "import 'package:$packageName/core/networking/api_result.dart';",
      "import 'package:$packageName/core/networking/base_client.dart';",
      "import 'package:$packageName/core/networking/enums_networking.dart';",
      "import 'package:$packageName/helper/constants/api_constants.dart';",
    };
    if (requests.any((r) => r.isFormData)) {
      imports.add("import 'package:dio/dio.dart';");
    }

    final methods = StringBuffer();
    for (final r in requests) {
      if (r.hasBodyModel) {
        imports.add(
            "import 'package:$packageName/app/models/${bodyModelFile(r)}';");
      }
      final params = <String>[
        for (final p in r.pathParams) 'String ${p.toDartIdentifier()}',
        if (r.hasBodyModel)
          '${bodyModelClass(r)} body'
        else if (r.body != null)
          'Object? body',
      ];
      final signature =
          [...params, '{Map<String, dynamic>? queryParameters}'].join(', ');
      var url = 'ApiConstants.${r.constantName}';
      for (final p in r.pathParams) {
        url +=
            ".replaceAll('{${p.escapeForDartString()}}', ${p.toDartIdentifier()})";
      }
      String? data;
      if (r.hasBodyModel) {
        data =
            r.isFormData ? 'FormData.fromMap(body.toJson())' : 'body.toJson()';
      } else if (r.body != null) {
        data = 'body';
      }
      methods.writeln('  /// ${r.requestType.name.toUpperCase()} ${r.path}');
      if (r.queryParams.isNotEmpty) {
        methods.writeln('  ///');
        methods.writeln(
            '  /// Query parameters: ${r.queryParams.map((q) => '`$q`').join(', ')}');
      }
      methods.writeln('  Future<ApiResult> ${_methodName(r)}($signature) {');
      methods.writeln('    return dioHelper.safeApiCall(');
      methods.writeln('      $url,');
      methods.writeln('      RequestType.${r.requestType.name},');
      if (data != null) methods.writeln('      data: $data,');
      methods.writeln('      queryParameters: queryParameters,');
      methods.writeln('    );');
      methods.writeln('  }');
      methods.writeln();
    }

    return '''
${(imports.toList()..sort()).join('\n')}

class $className {
  final DioHelper dioHelper;

  $className(this.dioHelper);

${methods.toString().trimRight()}
}
''';
  }

  /// GetX controller with one method per request of the group.
  static String controller(
      String group, List<RequestModel> requests, String packageName) {
    final className = '${group.toDartClassName()}Controller';
    final repoClass = '${group.toDartClassName()}Repo';
    final repoField = repoClass.lowerCaseFirstLetter();
    final imports = <String>{
      "import 'package:get/get.dart';",
      "import 'package:$packageName/app/repositories/${group}_repo.dart';",
      "import 'package:$packageName/core/networking/api_result.dart';",
      "import 'package:$packageName/core/networking/enums_networking.dart';",
    };

    final fields = StringBuffer();
    final methods = StringBuffer();
    for (final r in requests) {
      final name = _methodName(r);
      if (r.hasBodyModel) {
        imports.add(
            "import 'package:$packageName/app/models/${bodyModelFile(r)}';");
      }
      final hasResponse = r.responseExample != null;
      final responseField = '${name}Response';
      if (hasResponse) {
        imports.add(
            "import 'package:$packageName/app/models/${responseModelFile(r)}';");
        final model = responseModelClass(r);
        fields.writeln(responseIsList(r)
            ? '  List<$model> $responseField = [];'
            : '  $model? $responseField;');
      }
      final params = <String>[
        for (final p in r.pathParams) 'String ${p.toDartIdentifier()}',
        if (r.hasBodyModel)
          '${bodyModelClass(r)} body'
        else if (r.body != null)
          'Object? body',
      ];
      final args = <String>[
        for (final p in r.pathParams) p.toDartIdentifier(),
        if (r.body != null) 'body',
      ];
      String success = '// TODO: use result.data';
      if (hasResponse) {
        final model = responseModelClass(r);
        success = responseIsList(r)
            ? '$responseField = (result.data as List).whereType<Map<String, dynamic>>().map($model.fromJson).toList();'
            : '$responseField = $model.fromJson(result.data);';
      }
      methods.writeln('''
  Future<void> $name(${params.join(', ')}) async {
    apiResult = ApiResult(apiCallStatus: ApiCallStatus.loading);
    update();

    apiResult = await $repoField.$name(${args.join(', ')});
    apiResult.handelRequest(
      success: (result) {
        $success
      },
      error: (result) {
        // TODO: handle the error (result.message)
      },
    );

    update();
  }
''');
    }

    return '''
${(imports.toList()..sort()).join('\n')}

class $className extends GetxController {
  final $repoClass $repoField;

  $className({required this.$repoField});

  ApiResult apiResult = ApiResult();
${fields.isEmpty ? '' : '\n$fields'}
${methods.toString().trimRight()}
}
''';
  }

  static String _methodName(RequestModel r) => r.name.toDartIdentifier();

  static List<String> _params(RequestModel r) => [
        for (final p in r.pathParams) 'String ${p.toDartIdentifier()}',
        if (r.hasBodyModel)
          '${bodyModelClass(r)} body'
        else if (r.body != null)
          'Object? body',
      ];

  static List<String> _args(RequestModel r, {String prefix = ''}) => [
        for (final p in r.pathParams) '$prefix${p.toDartIdentifier()}',
        if (r.body != null) '${prefix}body',
      ];

  static Set<String> _modelImports(
          List<RequestModel> requests, String packageName) =>
      {
        for (final r in requests) ...[
          if (r.hasBodyModel)
            "import 'package:$packageName/app/models/${bodyModelFile(r)}';",
          if (r.responseExample != null)
            "import 'package:$packageName/app/models/${responseModelFile(r)}';",
        ],
      };

  /// `<group>_state.dart` for BLoC / Cubit projects (part of the bloc / cubit file).
  static String blocState(String group, List<RequestModel> requests,
      {required bool cubit}) {
    final className = '${group.toDartClassName()}State';
    final fields = <String, String>{}; // name => type
    final defaults = <String, String>{};
    for (final r in requests.where((r) => r.responseExample != null)) {
      final model = responseModelClass(r);
      final name = '${_methodName(r)}Response';
      if (responseIsList(r)) {
        fields[name] = 'List<$model>';
        defaults[name] = 'const []';
      } else {
        fields[name] = '$model?';
      }
    }
    final b = StringBuffer()
      ..writeln("part of '${group}_${cubit ? 'cubit' : 'bloc'}.dart';")
      ..writeln()
      ..writeln('class $className {')
      ..writeln('  final ApiResult apiResult;');
    fields.forEach((name, type) => b.writeln('  final $type $name;'));
    b
      ..writeln()
      ..writeln('  const $className({')
      ..writeln('    required this.apiResult,');
    fields.forEach((name, type) {
      b.writeln(defaults.containsKey(name)
          ? '    this.$name = ${defaults[name]},'
          : '    this.$name,');
    });
    b
      ..writeln('  });')
      ..writeln()
      ..writeln('  $className copyWith({')
      ..writeln('    ApiResult? apiResult,');
    fields.forEach((name, type) =>
        b.writeln('    ${type.endsWith('?') ? type : '$type?'} $name,'));
    b
      ..writeln('  }) {')
      ..writeln('    return $className(')
      ..writeln('      apiResult: apiResult ?? this.apiResult,');
    fields.forEach(
        (name, type) => b.writeln('      $name: $name ?? this.$name,'));
    b
      ..writeln('    );')
      ..writeln('  }')
      ..writeln('}');
    return b.toString();
  }

  /// `<group>_event.dart` for BLoC projects: one event per request.
  static String blocEvents(String group, List<RequestModel> requests) {
    final base = '${group.toDartClassName()}Event';
    final b = StringBuffer()
      ..writeln("part of '${group}_bloc.dart';")
      ..writeln()
      ..writeln('sealed class $base {}');
    for (final r in requests) {
      final event = '${r.name.toDartClassName()}Requested';
      final params = _params(r);
      b.writeln();
      b.writeln('/// ${r.requestType.name.toUpperCase()} ${r.path}');
      if (params.isEmpty) {
        b.writeln('final class $event extends $base {}');
        continue;
      }
      b.writeln('final class $event extends $base {');
      for (final param in params) {
        b.writeln('  final $param;');
      }
      b.writeln();
      b.writeln('  $event(${_args(r, prefix: 'this.').join(', ')});');
      b.writeln('}');
    }
    return b.toString();
  }

  static String _successLine(RequestModel r, String stateVar) {
    if (r.responseExample == null) return '// TODO: use result.data';
    final model = responseModelClass(r);
    final field = '${_methodName(r)}Response';
    final value = responseIsList(r)
        ? '(result.data as List).whereType<Map<String, dynamic>>().map($model.fromJson).toList()'
        : '$model.fromJson(result.data)';
    return '$stateVar = $stateVar.copyWith($field: $value);';
  }

  static String _handlerBody(
          RequestModel r, String repoField, List<String> args) =>
      '''
    emit(state.copyWith(apiResult: ApiResult(apiCallStatus: ApiCallStatus.loading)));

    final result = await $repoField.${_methodName(r)}(${args.join(', ')});
    var newState = state.copyWith(apiResult: result);
    result.handelRequest(
      success: (result) {
        ${_successLine(r, 'newState')}
      },
      error: (result) {
        // TODO: handle the error (result.message)
      },
    );
    emit(newState);''';

  /// `<group>_bloc.dart` for BLoC projects.
  static String bloc(
      String group, List<RequestModel> requests, String packageName) {
    final className = '${group.toDartClassName()}Bloc';
    final repoClass = '${group.toDartClassName()}Repo';
    final repoField = repoClass.lowerCaseFirstLetter();
    final event = '${group.toDartClassName()}Event';
    final state = '${group.toDartClassName()}State';
    final imports = <String>{
      "import 'package:flutter_bloc/flutter_bloc.dart';",
      "import 'package:$packageName/app/repositories/${group}_repo.dart';",
      "import 'package:$packageName/core/networking/api_result.dart';",
      "import 'package:$packageName/core/networking/enums_networking.dart';",
      ..._modelImports(requests, packageName),
    };
    final handlers = StringBuffer();
    final ons = StringBuffer();
    for (final r in requests) {
      final ev = '${r.name.toDartClassName()}Requested';
      final handler = '_on${r.name.toDartClassName()}';
      ons.writeln('    on<$ev>($handler);');
      handlers.writeln();
      handlers.writeln(
          '  Future<void> $handler($ev event, Emitter<$state> emit) async {');
      handlers.writeln(_handlerBody(r, repoField, _args(r, prefix: 'event.')));
      handlers.writeln('  }');
    }
    return '''
${(imports.toList()..sort()).join('\n')}

part '${group}_event.dart';
part '${group}_state.dart';

class $className extends Bloc<$event, $state> {
  final $repoClass $repoField;

  $className({required this.$repoField}) : super($state(apiResult: ApiResult())) {
${ons.toString().trimRight()}
  }
${handlers.toString().trimRight()}
}
''';
  }

  /// `<group>_cubit.dart` for Cubit projects: one method per request.
  static String cubit(
      String group, List<RequestModel> requests, String packageName) {
    final className = '${group.toDartClassName()}Cubit';
    final repoClass = '${group.toDartClassName()}Repo';
    final repoField = repoClass.lowerCaseFirstLetter();
    final state = '${group.toDartClassName()}State';
    final imports = <String>{
      "import 'package:flutter_bloc/flutter_bloc.dart';",
      "import 'package:$packageName/app/repositories/${group}_repo.dart';",
      "import 'package:$packageName/core/networking/api_result.dart';",
      "import 'package:$packageName/core/networking/enums_networking.dart';",
      ..._modelImports(requests, packageName),
    };
    final methods = StringBuffer();
    for (final r in requests) {
      methods.writeln();
      methods.writeln('  /// ${r.requestType.name.toUpperCase()} ${r.path}');
      methods.writeln(
          '  Future<void> ${_methodName(r)}(${_params(r).join(', ')}) async {');
      methods.writeln(_handlerBody(r, repoField, _args(r)));
      methods.writeln('  }');
    }
    return '''
${(imports.toList()..sort()).join('\n')}

part '${group}_state.dart';

class $className extends Cubit<$state> {
  final $repoClass $repoField;

  $className({required this.$repoField}) : super($state(apiResult: ApiResult()));
${methods.toString().trimRight()}
}
''';
  }
}
