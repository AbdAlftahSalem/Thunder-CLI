// Thunder CLI is used from the terminal:
//
//   dart pub global activate thunder_cli
//   thunder init my_app --org com.company --state bloc   (getx | bloc | cubit)
//   cd my_app
//   thunder feature profile
//   thunder model --name post --url https://jsonplaceholder.typicode.com/posts
//   thunder c_api --collection example/demo.postman_collection.json
//   thunder localization --from en --to ar
//
// The generators behind those commands can also be used from Dart code:

import 'package:thunder_cli/thunder_cli.dart';

void main() {
  // Build a model class (fromJson / toJson) from a JSON response.
  final model = ModelGenerator.generate('user', {
    'id': 1,
    'name': 'Abd',
    'address': {'city': 'Gaza', 'zip': 970},
    'tags': ['flutter', 'dart'],
  });
  print(model);

  // Read a Postman collection and build a repository for one folder.
  final collection = PostmanCollectionParser.parse({
    'variable': [
      {'key': 'base_url', 'value': 'https://dummyjson.com'},
    ],
    'item': [
      {
        'name': 'Products',
        'item': [
          {
            'name': 'Get product',
            'request': {'method': 'GET', 'url': '{{base_url}}/products/:id'},
          },
        ],
      },
    ],
  });
  for (final request in collection.requests) {
    request.constantName = request.name.toDartIdentifier();
  }
  print(ApiCodeGenerator.repo('products', collection.requests, 'my_app'));

  // The same folder as a Cubit (one method per request).
  print(ApiCodeGenerator.cubit('products', collection.requests, 'my_app'));

  // The files of a BLoC feature.
  print(BlocStrings.instance.bloc('profile', packageName: 'my_app'));
}
