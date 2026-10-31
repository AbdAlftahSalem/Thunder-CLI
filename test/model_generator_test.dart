import 'package:test/test.dart';
import 'package:thunder_cli/thunder_cli.dart';

void main() {
  group('ModelGenerator', () {
    test('builds fields, constructor, fromJson and toJson', () {
      final code = ModelGenerator.generate('post', {
        'id': 1,
        'title': 'Hello',
        'price': 9.5,
        'published': true,
        'tags': ['a', 'b'],
      });
      expect(code, contains('class PostModel {'));
      expect(code, contains('int? id;'));
      expect(code, contains('String? title;'));
      expect(code, contains('double? price;'));
      expect(code, contains('bool? published;'));
      expect(code, contains('List<String>? tags;'));
      expect(code, contains("id: (json['id'] as num?)?.toInt(),"));
      expect(code, contains("price: (json['price'] as num?)?.toDouble(),"));
      expect(code, contains("data['title'] = title;"));
    });

    test('nested objects and lists of objects get their own classes', () {
      final code = ModelGenerator.generate('user', {
        'address': {'city': 'Gaza'},
        'orders': [
          {'id': 1},
          {'id': 2, 'total': 10.5},
        ],
      });
      expect(code, contains('AddressModel? address;'));
      expect(code, contains('class AddressModel {'));
      expect(code, contains('List<OrdersModel>? orders;'));
      // keys of every list element are merged
      expect(code, contains('double? total;'));
      expect(code, contains('map(OrdersModel.fromJson)'));
      expect(
          code,
          contains(
              "data['orders'] = orders?.map((e) => e.toJson()).toList();"));
    });

    test('a list response uses the merged element keys', () {
      final code = ModelGenerator.generate('todo', [
        {'id': 1},
        {'id': 2, 'done': false},
      ]);
      expect(code, contains('class TodoModel {'));
      expect(code, contains('bool? done;'));
    });

    test('invalid keys are renamed, original keys kept in JSON', () {
      final code = ModelGenerator.generate(
          'weird', {'class': 'x', 'first-name': 'a', 'id': 1, '_id': 2});
      expect(code, contains('String? classValue;'));
      expect(code, contains("classValue: json['class']?.toString(),"));
      expect(code, contains('String? firstName;'));
      expect(code, contains('int? id2;'));
    });

    test('the Model suffix is not doubled', () {
      expect(ModelGenerator.generate('user_model', {'a': 1}),
          contains('class UserModel {'));
    });

    test('class name collisions are resolved', () {
      final code = ModelGenerator.generate('root', {
        'a': {
          'data': {'x': 1}
        },
        'b': {
          'data': {'y': 2}
        },
      });
      expect(code, contains('class DataModel {'));
      expect(code, contains('class BDataModel {'));
    });

    test('rejects values that are not objects', () {
      expect(() => ModelGenerator.generate('x', 'text'), throwsArgumentError);
      expect(() => ModelGenerator.generate('x', [1, 2]), throwsArgumentError);
    });
  });
}
