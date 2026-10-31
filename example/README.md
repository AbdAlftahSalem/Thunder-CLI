# Thunder CLI examples

* [`example.dart`](example.dart) — use the generators from Dart code.
* [`demo.postman_collection.json`](demo.postman_collection.json) — a small
  Postman collection to try `thunder c_api` with.
* [`todo.json`](todo.json) — a JSON response to try `thunder model --json` with.

```bash
dart pub global activate thunder_cli

# pick one: getx, bloc or cubit
thunder init demo_app --org com.example --state cubit -y
cd demo_app
thunder feature profile
thunder model --name task --json path/to/todo.json
thunder c_api --collection path/to/demo.postman_collection.json
thunder localization --from en --to ar,fr
flutter run
```

| `--state` | `thunder feature profile` creates |
| --- | --- |
| `getx` | `profile_controller.dart`, `profile_view.dart`, `profile_repo.dart` |
| `bloc` | `bloc/profile_bloc.dart`, `bloc/profile_event.dart`, `bloc/profile_state.dart`, `profile_view.dart`, `profile_repo.dart` |
| `cubit` | `cubit/profile_cubit.dart`, `cubit/profile_state.dart`, `profile_view.dart`, `profile_repo.dart` |
