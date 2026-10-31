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
}
