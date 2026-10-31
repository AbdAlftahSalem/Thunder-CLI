## 3.0.0

Thunder CLI was rebuilt so every command works again, on current Flutter and Dart.

**Breaking**
- Commands are now sub-commands: `thunder init`, `thunder feature <name>`,
  `thunder model`, `thunder c_api`, `thunder localization`. The old flags
  (`thunder --init`, `--feature`, `--model`, `--c_api`, `--localization`,
  `--help`) still work.
- Generated features live in `lib/app/features/<name>/` and use `package:`
  imports.
- Minimum Dart SDK is 3.4.

**Fixed**
- `thunder`, `thunder --help` and `thunder --c_api` crashed with
  `Could not find an option named "--c_api"`.
- `thunder --init` failed: it cloned a template repository that no longer
  exists. `init` now runs `flutter create` and writes the GetX + MVC structure
  itself, so it no longer depends on any external repository.
- `thunder --feature` generated controllers and repositories with wrong
  import paths, so the app did not compile.
- Windows-only commands (`rd /s /q`, `\` paths) broke Thunder on macOS and
  Linux.
- `thunder --model` asked for a feature name it never used and generated
  models that crashed on nested lists, numbers sent as `1` instead of `1.0`,
  and keys such as `class`, `first-name` or `2fa`.
- `thunder --localization` crashed when `thunder.json` did not exist.

**New**
- `thunder init my_app --org com.company`: app + packages (`get`, `dio`),
  routing, bindings, `DioHelper` + `ApiResult`, light/dark theme,
  translations, a home feature and a passing widget test. Optional git
  repository, first push to GitHub, Telegram APK GitHub Action and VS Code.
- `thunder feature <name>`: view, controller, repository, API endpoint,
  binding and route in one command. Existing files are never overwritten
  without `--force`.
- `thunder model`: from a URL (`--url`, `--method`, `--body`, `--headers`)
  or a local file (`--json`).
- `thunder c_api`: Postman v2.0 / v2.1 collections with nested folders, path
  variables (`:id`, `{{id}}`), query parameters, raw JSON / form-data /
  urlencoded bodies and saved example responses (typed response models).
- `thunder localization --from en --to ar,fr`: only new texts are translated;
  languages are remembered in `thunder.json`.
- Every option can be passed on the command line and `--yes` never asks
  questions, so Thunder works in scripts and CI.
- Generated files are formatted with `dart format`.
- Unit tests, an end-to-end script (`tool/e2e.sh`) and GitHub Actions CI.

## 2.3.5
- Update package structure

## 2.3.4
- Fix bug when clone repository

## 2.3.3
- Solve the problem when installing the package

## 2.3.2
- Enhancement package

## 2.3.1
- Update architecture
