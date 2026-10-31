<p align="center">
  <img src="https://raw.githubusercontent.com/AbdAlftahSalem/Thunder-CLI/main/assets/images/logo.png" width="220" alt="Thunder CLI logo"/>
</p>

<h1 align="center">⚡ Thunder CLI</h1>

<p align="center">
  Create Flutter apps with <b>GetX</b>, <b>BLoC</b> or <b>Cubit</b> in seconds, then generate features,
  API models, Postman collection code and translations from the command line.
</p>

<p align="center">
  <a href="https://pub.dev/packages/thunder_cli"><img src="https://img.shields.io/pub/v/thunder_cli.svg" alt="pub version"></a>
  <a href="https://pub.dev/packages/thunder_cli/score"><img src="https://img.shields.io/pub/points/thunder_cli" alt="pub points"></a>
  <a href="https://github.com/AbdAlftahSalem/Thunder-CLI/actions/workflows/ci.yaml"><img src="https://github.com/AbdAlftahSalem/Thunder-CLI/actions/workflows/ci.yaml/badge.svg" alt="CI"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT license"></a>
</p>

---

## ✨ What it does

| Command | What you get |
| --- | --- |
| `thunder init` | A new Flutter app (GetX, BLoC or Cubit) with networking, services, middleware, DI, routing, localization, theme and sample features |
| `thunder feature <name>` | View + controller / bloc / cubit + repository + API endpoint + DI + route |
| `thunder model` | A model class (`fromJson` / `toJson`) from an API response or a JSON file |
| `thunder c_api` | API constants, body/response models, repositories and controllers / blocs / cubits from a Postman collection |
| `thunder localization` | Your texts translated to any language and wired into the app |

Everything Thunder generates compiles and passes `flutter analyze` on the current Flutter stable,
for all three state managements (checked on every change by `tool/e2e.sh`).

| | GetX | BLoC | Cubit |
| --- | --- | --- | --- |
| State | `GetxController` | `Bloc` + events + state | `Cubit` + state |
| DI | `Get.lazyPut` (`bindings_app.dart`) | `get_it` (`injection.dart`) | `get_it` (`injection.dart`) |
| Routing | `GetPage` | `go_router` | `go_router` |
| Middleware | `GetMiddleware` | `go_router` redirect guard | `go_router` redirect guard |
| Template | [`getx` branch](https://github.com/AbdAlftahSalem/Thunder-Template/tree/getx) | [`bloc` branch](https://github.com/AbdAlftahSalem/Thunder-Template/tree/bloc) | [`cubit` branch](https://github.com/AbdAlftahSalem/Thunder-Template/tree/cubit) |

## 📌 Installation

```bash
dart pub global activate thunder_cli
```

Make sure the pub cache `bin` folder is in your `PATH`
([how](https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path)).
You also need [Flutter](https://docs.flutter.dev/get-started/install) installed for `thunder init`.

```bash
thunder version
```

## 🚀 Quick start

**GetX**

```bash
thunder init shop_app --org com.company --state getx
cd shop_app
thunder feature product_details     # controller + view + repo, Get.toNamed(Routes.PRODUCT_DETAILS)
flutter run
```

**BLoC**

```bash
thunder init shop_app --org com.company --state bloc
cd shop_app
thunder feature product_details     # bloc + event + state + view + repo, context.push(Routes.PRODUCT_DETAILS)
flutter run
```

**Cubit**

```bash
thunder init shop_app --org com.company --state cubit
cd shop_app
thunder feature product_details     # cubit + state + view + repo, context.push(Routes.PRODUCT_DETAILS)
flutter run
```

Leave out `--state` and Thunder asks (GetX is the default). The choice is saved in `thunder.json`,
so every later command generates code for the right style.

## 🧑🏻‍💻 Commands

Run any command without options and Thunder asks for what it needs.
Pass the options to skip the questions, and add `-y` (`--yes`) to never be asked anything (CI, scripts).

### `thunder init [name]`

Runs `flutter create` (platform folders and application id), then puts the template for your state management on
top of it: `lib/`, `test/`, `assets/`, `pubspec.yaml` and `analysis_options.yaml`, renamed to your app.
The templates live in [Thunder-Template](https://github.com/AbdAlftahSalem/Thunder-Template) (one branch per style);
when there is no internet Thunder uses the copy bundled with it.

```bash
thunder init shop_app --org com.company --state bloc
thunder init shop_app --org com.company --state getx --title "Shop" --platforms android,ios --remote https://github.com/me/shop_app.git
thunder init shop_app --template https://github.com/me/my_template#main   # your own template
```

| Option | Description |
| --- | --- |
| `--state`, `-s` | `getx`, `bloc` or `cubit` (asked when missing, default `getx`) |
| `--org` | Organization in reverse domain notation (`com.company` → app id `com.company.shop_app`) |
| `--title` | App title (default: from the name, `Shop App`) |
| `--path` | Folder to create the project in (default: the name) |
| `--platforms` | Platforms for `flutter create` (default: all) |
| `--template` | Your own template: GitHub URL (add `#branch`), git URL, `.zip` URL or a local folder |
| `--offline` | Use the template bundled with Thunder (no download) |
| `--[no-]git` | Create a git repository with a first commit (default: on) |
| `--remote` | Push the first commit to this GitHub repository |
| `--[no-]github-action` | Add a workflow that builds the APK and sends it to Telegram |
| `--[no-]vscode` | Open the project in VS Code |

What you get (BLoC shown; GetX uses `bindings/` and `app_routes.dart`, Cubit uses `cubit/` folders):

```
lib/
├── main.dart                         MaterialApp.router + SettingsBloc (theme & language)
├── core/
│   ├── di/injection.dart             get_it: sl<HomeRepo>()
│   ├── config/app_config.dart        app name + environment (--dart-define=ENV=prod)
│   ├── middlewares/auth_guard.dart   route guard
│   ├── networking/                   DioHelper (token interceptor) → ApiResult, ApiCallStatus, RequestType
│   ├── routing/                      routes.dart + app_router.dart
│   ├── services/                     StorageService, ThemeService, LocalizationService
│   └── theme/app_theme.dart          Material 3 light & dark themes
├── helper/
│   ├── constants/                    api_constants.dart (BASE_URL), strings_constants.dart
│   ├── translations/                 en + ar, local.dart
│   └── widgets/                      CustomText, CustomButton, ApiStateWidget
└── app/
    ├── features/home/                home_view.dart + bloc/ (a list loaded from an API)
    ├── features/settings/            dark mode + language switch, saved locally
    ├── repositories/home_repo.dart
    └── models/todo_model.dart
```

### `thunder feature <name>`

```bash
thunder feature product_details
```

GetX:

```
✅ Create lib/app/features/product_details/product_details_controller.dart
✅ Create lib/app/features/product_details/product_details_view.dart
✅ Create lib/app/repositories/product_details_repo.dart
✅ Register 'product_details' in bindings_app.dart
✅ Add '/product_details' to routes.dart and app_routes.dart
```

BLoC:

```
✅ Create lib/app/features/product_details/bloc/product_details_bloc.dart
✅ Create lib/app/features/product_details/bloc/product_details_event.dart
✅ Create lib/app/features/product_details/bloc/product_details_state.dart
✅ Create lib/app/features/product_details/product_details_view.dart
✅ Create lib/app/repositories/product_details_repo.dart
✅ Register 'product_details' in injection.dart
✅ Add '/product_details' to routes.dart and app_router.dart
```

Cubit:

```
✅ Create lib/app/features/product_details/cubit/product_details_cubit.dart
✅ Create lib/app/features/product_details/cubit/product_details_state.dart
✅ Create lib/app/features/product_details/product_details_view.dart
✅ Create lib/app/repositories/product_details_repo.dart
✅ Register 'product_details' in injection.dart
✅ Add '/product_details' to routes.dart and app_router.dart
```

The new page loads `ApiConstants.productDetails` when it opens and shows loading / error / empty / data states.
Open it with `Get.toNamed(Routes.PRODUCT_DETAILS)` (GetX) or `context.push(Routes.PRODUCT_DETAILS)` (BLoC / Cubit).
Existing files are kept; use `--force` to overwrite.

Thunder finds the style in `thunder.json`. In a project without it (for example one made with **Use this template**),
it looks at the files: `lib/core/di/injection.dart` means BLoC (or Cubit when there are `cubit/` folders), otherwise GetX.

### `thunder model`

```bash
# from an API
thunder model --name post --url https://jsonplaceholder.typicode.com/posts
thunder model --name login --url https://dummyjson.com/auth/login --method post \
  --body '{"username": "emilys", "password": "emilyspass"}'

# from a JSON file
thunder model --name user --json user.json
```

Creates `lib/app/models/post_model.dart`:

```dart
class PostModel {
  int? userId;
  int? id;
  String? title;
  String? body;

  PostModel({this.userId, this.id, this.title, this.body});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      userId: (json['userId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      title: json['title']?.toString(),
      body: json['body']?.toString(),
    );
  }

  Map<String, dynamic> toJson() { ... }
}
```

Nested objects become their own classes, lists of objects become `List<XModel>` (keys of every element are merged),
numbers are read safely and keys like `class`, `first-name` or `2fa` are renamed to valid Dart names.

### `thunder c_api`

Export your collection from Postman (**Export → Collection v2.1**), then:

```bash
thunder c_api --collection my_api.postman_collection.json
```

```
✅ Read 2 variables and 8 requests (BLoC project)
✅ Add 8 routes to api_constants.dart
✅ Build 4 models
✅ Build 3 repositories and blocs: auth, products, general

   POST   auth/login     →  AuthBloc ← LoginRequested
   GET    products/{id}  →  ProductsBloc ← GetProductRequested
```

- One repository per top-level folder (requests outside folders go to `general`), plus a controller (GetX),
  a bloc with one event per request (BLoC) or a cubit with one method per request (Cubit).
- Typed responses are kept in the bloc / cubit state (`state.loginResponse`).
- The base URL variable (`{{base_url}}`) becomes `ApiConstants.baseUrl`.
- Path variables (`:id`, `{{id}}`) become method parameters.
- JSON bodies become body models; saved example responses become typed response models.
- form-data bodies are sent as `FormData`.

Try it with [`example/demo.postman_collection.json`](example/demo.postman_collection.json).

### `thunder localization`

Write your texts in `lib/helper/constants/strings_constants.dart`:

```dart
class StringsConstants {
  static const String home = "Home";
  static const String login = "Log in";
}
```

Then:

```bash
thunder localization --from en --to ar,fr
```

Thunder writes `ar_translation.dart`, `fr_translation.dart`, registers them in `local.dart` and adds them to
`LocalizationService.supportedLocales`. Use the texts with `Text(StringsConstants.home.tr)` in every style.
Switch language with `LocalizationService.changeLocale('ar')` (GetX) or the settings bloc / cubit
(`SettingsLanguageChanged('ar')` / `changeLanguage('ar')`); the template's settings page already does it.
Run the command again after adding texts: only the new ones are translated. Translations come from Google Translate,
so review them before you ship.

## 🔁 Upgrading from 2.x

The old flags still work (`thunder --init`, `--feature`, `--model`, `--c_api`, `--localization`, `--help`).
Projects made with 2.x are GetX projects, and Thunder treats them that way.

In a project created with 2.x, Thunder adds new routes and bindings after your existing ones when it cannot find
its `// thunder:` markers. The generated code expects the 3.0 networking files (`lib/core/networking/`:
`DioHelper.safeApiCall`, `ApiResult`, `ApiCallStatus`, `RequestType`), so compare yours with a fresh
`thunder init` project first.

## 🧪 Development

```bash
dart pub get
dart test            # unit tests
./tool/e2e.sh        # for getx, bloc and cubit: creates an app, runs every command,
                     # then flutter analyze + flutter test

# after changing the Thunder-Template branches, refresh the offline copy:
dart run tool/bundle_templates.dart <getx-dir> <bloc-dir> <cubit-dir>
```

## 🤝 Contributing

Issues and pull requests are welcome. Please run `dart format .`, `dart analyze` and `dart test` before opening a PR.

## 📨 Contact

[WhatsApp](https://wa.me/972598045064) · [Telegram](https://t.me/Abd_Alftah_Al_shanti) · [GitHub](https://github.com/AbdAlftahSalem)

## 📄 License

MIT — see [LICENSE](LICENSE).
