import 'package:test/test.dart';
import 'package:thunder_cli/src/core/networking/dio_handler.dart';
import 'package:thunder_cli/thunder_cli.dart';

Map<String, dynamic> collection() => {
      'info': {'name': 'Demo'},
      'variable': [
        {'key': 'base_url', 'value': 'https://dummyjson.com'},
      ],
      'item': [
        {
          'name': 'Auth',
          'item': [
            {
              'name': 'Login',
              'request': {
                'method': 'POST',
                'body': {
                  'mode': 'raw',
                  'raw': '{"username": "emilys", "password": "x"}'
                },
                'url': {'raw': '{{base_url}}/auth/login'},
              },
              'response': [
                {'body': '{"id": 1, "accessToken": "t"}'},
              ],
            },
          ],
        },
        {
          'name': 'Products',
          'item': [
            {
              'name': 'Get product',
              'request': {
                'method': 'GET',
                'url': '{{base_url}}/products/:id?select=title'
              },
            },
            {
              'name': 'Nested',
              'item': [
                {
                  'name': 'Delete product',
                  'request': {
                    'method': 'DELETE',
                    'url': '{{base_url}}/products/{{productId}}'
                  },
                },
              ],
            },
          ],
        },
        {
          'name': 'Health check',
          'request': {'method': 'GET', 'url': 'https://dummyjson.com/test'},
        },
      ],
    };

void main() {
  group('PostmanCollectionParser', () {
    final parsed = PostmanCollectionParser.parse(collection());

    test('reads the base url and every request (nested folders included)', () {
      expect(parsed.baseUrl, 'https://dummyjson.com/');
      expect(parsed.requests.map((r) => r.name),
          ['login', 'get_product', 'delete_product', 'health_check']);
      expect(parsed.requests.map((r) => r.group),
          ['auth', 'products', 'products', 'general']);
    });

    test('paths are relative with {param} placeholders', () {
      final byName = {for (final r in parsed.requests) r.name: r};
      expect(byName['login']!.path, 'auth/login');
      expect(byName['login']!.requestType, RequestType.post);
      expect(byName['get_product']!.path, 'products/{id}');
      expect(byName['get_product']!.pathParams, ['id']);
      expect(byName['get_product']!.queryParams, ['select']);
      expect(byName['delete_product']!.path, 'products/{productId}');
      expect(byName['health_check']!.path, 'test');
    });

    test('decodes JSON bodies and example responses', () {
      final login = parsed.requests.first;
      expect(login.body, {'username': 'emilys', 'password': 'x'});
      expect(login.hasBodyModel, isTrue);
      expect(login.responseExample, {'id': 1, 'accessToken': 't'});
    });
  });

  group('ApiCodeGenerator', () {
    final parsed = PostmanCollectionParser.parse(collection());
    for (final r in parsed.requests) {
      r.constantName = r.name.toDartIdentifier();
    }
    final products =
        parsed.requests.where((r) => r.group == 'products').toList();
    final auth = parsed.requests.where((r) => r.group == 'auth').toList();

    test('repo has one method per request with path params', () {
      final code = ApiCodeGenerator.repo('products', products, 'demo');
      expect(code, contains('class ProductsRepo {'));
      expect(
          code,
          contains(
              'Future<ApiResult> getProduct(String id, {Map<String, dynamic>? queryParameters})'));
      expect(code, contains("ApiConstants.getProduct.replaceAll('{id}', id)"));
      expect(code, contains('RequestType.delete'));
      expect(code,
          contains("import 'package:demo/core/networking/base_client.dart';"));
    });

    test('repo sends the body model as JSON', () {
      final code = ApiCodeGenerator.repo('auth', auth, 'demo');
      expect(code, contains('Future<ApiResult> login(LoginBodyModel body'));
      expect(code, contains('data: body.toJson(),'));
      expect(code,
          contains("import 'package:demo/app/models/login_body_model.dart';"));
    });

    test('controller stores the typed response', () {
      final code = ApiCodeGenerator.controller('auth', auth, 'demo');
      expect(code, contains('class AuthController extends GetxController {'));
      expect(code, contains('LoginResponseModel? loginResponse;'));
      expect(
          code,
          contains(
              'loginResponse = LoginResponseModel.fromJson(result.data);'));
      expect(code, contains('apiResult = await authRepo.login(body);'));
    });
  });
}
