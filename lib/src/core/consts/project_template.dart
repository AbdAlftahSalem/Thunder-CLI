/// The files `thunder init` writes on top of a fresh `flutter create`
/// project. Placeholders: `{{PACKAGE}}` (package name) and `{{TITLE}}`
/// (application title).
///
/// Everything here only depends on `get` and `dio`, which `thunder init` adds
/// with `flutter pub add`.
class ProjectTemplate {
  /// Map of project-relative path => file content.
  static Map<String, String> files({
    required String packageName,
    required String title,
  }) {
    String fill(String content) =>
        content.replaceAll('{{PACKAGE}}', packageName).replaceAll(
            '{{TITLE}}', title.replaceAll("'", r"\'").replaceAll('"', r'\"'));

    return {
      'lib/main.dart': fill(_main),
      'lib/core/bindings/bindings_app.dart': fill(_bindings),
      'lib/core/networking/api_result.dart': fill(_apiResult),
      'lib/core/networking/base_client.dart': fill(_baseClient),
      'lib/core/networking/enums_networking.dart': fill(_enums),
      'lib/core/routing/routes.dart': fill(_routes),
      'lib/core/routing/app_routes.dart': fill(_appRoutes),
      'lib/core/theme/app_theme.dart': fill(_theme),
      'lib/helper/constants/api_constants.dart': fill(_apiConstants),
      'lib/helper/constants/strings_constants.dart': fill(_strings),
      'lib/helper/translations/en_translation.dart': fill(_enTranslation),
      'lib/helper/translations/local.dart': fill(_local),
      'lib/helper/widgets/custom_widgets/custom_text.dart': fill(_customText),
      'test/widget_test.dart': fill(_test),
    };
  }

  static const String _main = r'''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/bindings/bindings_app.dart';
import 'core/routing/app_routes.dart';
import 'core/routing/routes.dart';
import 'core/theme/app_theme.dart';
import 'helper/translations/local.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '{{TITLE}}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      translations: MyLocal(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      initialBinding: BindingApp(),
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
    );
  }
}
''';

  static const String _bindings = r'''
import 'package:get/get.dart';

import '../networking/base_client.dart';
// thunder:imports

/// App-wide dependency injection. `thunder feature` and `thunder c_api`
/// register new repositories and controllers here.
class BindingApp extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DioHelper(), fenix: true);
    // thunder:bindings
  }
}
''';

  static const String _enums = r'''
/// State of an API call, used by views to show loading / error / data.
enum ApiCallStatus { holding, loading, success, empty, error }

/// HTTP methods supported by [DioHelper.safeApiCall].
enum RequestType { get, post, put, patch, delete }
''';

  static const String _apiResult = r'''
import 'enums_networking.dart';

/// Result of every API call made through `DioHelper.safeApiCall`.
class ApiResult<T> {
  T? data;
  String? message;
  int? statusCode;
  ApiCallStatus apiCallStatus;

  ApiResult({
    this.data,
    this.message,
    this.statusCode,
    this.apiCallStatus = ApiCallStatus.holding,
  });

  factory ApiResult.success({T? data, int? statusCode}) => ApiResult(
        data: data,
        statusCode: statusCode,
        apiCallStatus: ApiCallStatus.success,
      );

  factory ApiResult.error({
    String? message,
    int? statusCode,
    ApiCallStatus apiCallStatus = ApiCallStatus.error,
  }) =>
      ApiResult(
        message: message,
        statusCode: statusCode,
        apiCallStatus: apiCallStatus,
      );

  bool get isLoading => apiCallStatus == ApiCallStatus.loading;

  bool get isSuccess =>
      apiCallStatus == ApiCallStatus.success || apiCallStatus == ApiCallStatus.empty;

  bool get isError => apiCallStatus == ApiCallStatus.error;

  /// Calls [success] or [error] depending on the result.
  void handelRequest({
    required void Function(ApiResult<T> result) success,
    required void Function(ApiResult<T> result) error,
  }) {
    if (isSuccess) {
      success(this);
    } else if (isError) {
      error(this);
    }
  }

  /// Same as [handelRequest].
  void handleRequest({
    required void Function(ApiResult<T> result) success,
    required void Function(ApiResult<T> result) error,
  }) =>
      handelRequest(success: success, error: error);
}
''';

  static const String _baseClient = r'''
import 'package:dio/dio.dart';

import '../../helper/constants/api_constants.dart';
import 'api_result.dart';
import 'enums_networking.dart';

/// Thin wrapper around [Dio]. Every request returns an [ApiResult] and never
/// throws, so controllers only have to check `apiResult.apiCallStatus`.
class DioHelper {
  DioHelper({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: const Duration(seconds: 20),
                receiveTimeout: const Duration(seconds: 20),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  final Dio _dio;

  /// The underlying Dio instance (add interceptors here).
  Dio get dio => _dio;

  /// Sets (or removes, when [token] is null) the `Authorization` header.
  void setToken(String? token, {String type = 'Bearer'}) {
    if (token == null || token.isEmpty) {
      _dio.options.headers.remove('Authorization');
    } else {
      _dio.options.headers['Authorization'] = '$type $token';
    }
  }

  /// Performs a request and wraps the response (or the error) in an [ApiResult].
  Future<ApiResult> safeApiCall(
    String url,
    RequestType requestType, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          method: requestType.name.toUpperCase(),
          headers: headers,
        ),
      );
      final body = response.data;
      final isEmpty = body == null ||
          (body is List && body.isEmpty) ||
          (body is Map && body.isEmpty);
      return ApiResult(
        data: body,
        statusCode: response.statusCode,
        apiCallStatus: isEmpty ? ApiCallStatus.empty : ApiCallStatus.success,
      );
    } on DioException catch (e) {
      return ApiResult.error(
        message: _errorMessage(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResult.error(message: e.toString());
    }
  }

  String _errorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return e.message ?? 'Something went wrong';
    }
  }
}
''';

  static const String _routes = r'''
// ignore_for_file: constant_identifier_names

/// Route names. `thunder feature` adds a route for every new feature.
abstract class Routes {
  static const HOME = '/home';
  // thunder:routes
}
''';

  static const String _appRoutes = r'''
import 'package:get/get.dart';

import 'package:{{PACKAGE}}/app/features/home/home_view.dart';
// thunder:imports
import 'routes.dart';

/// All the pages of the app.
class AppPages {
  static final routes = [
    GetPage(name: Routes.HOME, page: () => const HomeView()),
    // thunder:pages
  ];
}
''';

  static const String _theme = r'''
import 'package:flutter/material.dart';

/// Light and dark themes of the app.
class AppTheme {
  static const Color seedColor = Color(0xFF6750A4);

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );
}
''';

  static const String _apiConstants = r'''
/// API base URL and endpoints. `thunder feature` and `thunder c_api` add
/// endpoints here.
class ApiConstants {
  static const baseUrl = 'https://jsonplaceholder.typicode.com/';
  static const home = 'todos';
  // thunder:endpoints
}
''';

  static const String _strings = r'''
/// Every text shown in the app. Use them with GetX translations:
/// `Text(StringsConstants.home.tr)`.
///
/// Add new texts here, then run `thunder localization` to translate them.
class StringsConstants {
  static const String appName = "{{TITLE}}";
  static const String home = "Home";
  static const String somethingWentWrong = "Something went wrong";
  static const String noData = "No data yet";
}
''';

  static const String _enTranslation = r'''
import '../constants/strings_constants.dart';

final Map<String, String> enLanguage = {
  StringsConstants.appName: "{{TITLE}}",
  StringsConstants.home: "Home",
  StringsConstants.somethingWentWrong: "Something went wrong",
  StringsConstants.noData: "No data yet",
};
''';

  static const String _local = r'''
import 'package:get/get.dart';

import 'en_translation.dart';

/// GetX translations. `thunder localization` adds new languages here.
class MyLocal implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enLanguage,
      };
}
''';

  static const String _customText = r'''
import 'package:flutter/material.dart';

/// Text widget used across the app.
class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.txt,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
  });

  final String txt;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
''';

  static const String _test = r'''
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:{{PACKAGE}}/core/networking/api_result.dart';
import 'package:{{PACKAGE}}/core/networking/enums_networking.dart';
import 'package:{{PACKAGE}}/helper/widgets/custom_widgets/custom_text.dart';

void main() {
  testWidgets('CustomText shows its text', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: CustomText(txt: 'Thunder'))),
    );
    expect(find.text('Thunder'), findsOneWidget);
  });

  test('ApiResult.handelRequest calls the right callback', () {
    var called = '';
    ApiResult(apiCallStatus: ApiCallStatus.success).handelRequest(
      success: (_) => called = 'success',
      error: (_) => called = 'error',
    );
    expect(called, 'success');

    ApiResult.error(message: 'boom').handelRequest(
      success: (_) => called = 'success',
      error: (_) => called = 'error',
    );
    expect(called, 'error');
  });
}
''';
}
