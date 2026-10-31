# Thunder CLI examples

* [`example.dart`](example.dart) — use the generators from Dart code.
* [`demo.postman_collection.json`](demo.postman_collection.json) — a small
  Postman collection to try `thunder c_api` with.
* [`todo.json`](todo.json) — a JSON response to try `thunder model --json` with.

```bash
dart pub global activate thunder_cli
thunder init demo_app --org com.example -y
cd demo_app
thunder feature profile
thunder model --name todo --json path/to/todo.json
thunder c_api --collection path/to/demo.postman_collection.json
thunder localization --from en --to ar
flutter run
```
