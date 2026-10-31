<p align="center">
  <img src="https://raw.githubusercontent.com/AbdAlftahSalem/Thunder-CLI/main/assets/images/logo.png" width="220" alt="Thunder CLI logo"/>
</p>

<h1 align="center">⚡ Thunder CLI</h1>

<p align="center">
  Create Flutter apps with <b>GetX + MVC</b> in seconds, then generate features, API models,
  Postman collection code and translations from the command line.
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
| `thunder init` | A new Flutter app with GetX, Dio, routing, bindings, theme, translations and a home screen |
| `thunder feature <name>` | View + controller + repository + API endpoint + binding + route |
| `thunder model` | A model class (`fromJson` / `toJson`) from an API response or a JSON file |
| `thunder c_api` | API constants, body/response models, repositories and controllers from a Postman collection |
| `thunder localization` | Your texts translated to any language and wired into GetX translations |

Everything Thunder generates compiles and passes `flutter analyze` on the current Flutter stable.

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

```bash
thunder init shop_app --org com.company
cd shop_app
thunder feature product_details
flutter run
```

## 🧑🏻‍💻 Commands

Run any command without options and Thunder asks for what it needs.
Pass the options to skip the questions, and add `-y` (`--yes`) to never be asked anything (CI, scripts).

### `thunder init [name]`

Creates the project with `flutter create`, adds `get` and `dio`, and writes the Thunder structure.

```bash
thunder init shop_app --org com.company
thunder init shop_app --org com.company --title "Shop" --platforms android,ios --remote https://github.com/me/shop_app.git
```

| Option | Description |
| --- | --- |
| `--org` | Organization in reverse domain notation (`com.company` → app id `com.company.shop_app`) |
| `--title` | App title (default: from the name, `Shop App`) |
| `--path` | Folder to create the project in (default: the name) |
| `--platforms` | Platforms for `flutter create` (default: all) |
| `--[no-]git` | Create a git repository with a first commit (default: on) |
| `--remote` | Push the first commit to this GitHub repository |
| `--[no-]github-action` | Add a workflow that builds the APK and sends it to Telegram |
| `--[no-]vscode` | Open the project in VS Code |

What you get:

```
lib/
├── main.dart                      GetMaterialApp with routes, bindings, theme, translations
├── core/
│   ├── bindings/bindings_app.dart dependency injection (Get.lazyPut)
│   ├── networking/                DioHelper.safeApiCall → ApiResult, ApiCallStatus, RequestType
│   ├── routing/                   routes.dart + app_routes.dart (GetPage list)
│   └── theme/app_theme.dart       light & dark Material 3 themes
├── helper/
│   ├── constants/                 api_constants.dart, strings_constants.dart
│   ├── translations/              en_translation.dart, local.dart
│   └── widgets/custom_widgets/    custom_text.dart
└── app/
    ├── features/home/             home_view.dart, home_controller.dart
    ├── repositories/              home_repo.dart
    └── models/
```

### `thunder feature <name>`

```bash
thunder feature product_details
```

```
✅ Create lib/app/features/product_details/product_details_controller.dart
✅ Create lib/app/features/product_details/product_details_view.dart
✅ Create lib/app/repositories/product_details_repo.dart
✅ Register 'product_details' in bindings_app.dart
✅ Add '/product_details' to routes.dart and app_routes.dart
```

Open it with `Get.toNamed(Routes.PRODUCT_DETAILS)`. The controller loads `ApiConstants.productDetails`
on start and the view shows loading / error / empty / data states. Existing files are kept; use `--force` to overwrite.

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
✅ Read 2 variables and 8 requests
✅ Add 8 routes to api_constants.dart
✅ Build 4 models
✅ Build 3 repositories and controllers: auth, products, general

   POST   auth/login     →  AuthController.login()
   GET    products/{id}  →  ProductsController.getProduct()
```

- One repository + controller per top-level folder (requests outside folders go to `general`).
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

Thunder writes `ar_translation.dart`, `fr_translation.dart` and registers them in `local.dart`.
Use the texts with `Text(StringsConstants.home.tr)` and switch language with `Get.updateLocale(const Locale('ar'))`.
Run the command again after adding texts: only the new ones are translated. Translations come from Google Translate,
so review them before you ship.

## 🔁 Upgrading from 2.x

The old flags still work (`thunder --init`, `--feature`, `--model`, `--c_api`, `--localization`, `--help`).

In a project created with 2.x, Thunder adds new routes and bindings after your existing ones when it cannot find
its `// thunder:` markers. The generated code expects the 3.0 networking files (`lib/core/networking/`:
`DioHelper.safeApiCall`, `ApiResult`, `ApiCallStatus`, `RequestType`), so compare yours with a fresh
`thunder init` project first.

## 🧪 Development

```bash
dart pub get
dart test            # unit tests
./tool/e2e.sh        # creates an app, runs every command, then flutter analyze + flutter test
```

## 🤝 Contributing

Issues and pull requests are welcome. Please run `dart format .`, `dart analyze` and `dart test` before opening a PR.

## 📨 Contact

[WhatsApp](https://wa.me/972598045064) · [Telegram](https://t.me/Abd_Alftah_Al_shanti) · [GitHub](https://github.com/AbdAlftahSalem)

## 📄 License

MIT — see [LICENSE](LICENSE).
