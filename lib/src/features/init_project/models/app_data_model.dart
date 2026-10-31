import '../../../core/consts/state_management.dart';

/// Everything `thunder init` needs to create a project.
class AppDataModel {
  /// Package name of the app, in snake_case (`my_app`).
  String appName;

  /// Organization in reverse domain notation (`com.example`). The final
  /// application id is `<organization>.<appName>`.
  String organization;

  /// Human readable title shown in the app (`My App`).
  String title;

  /// Folder the project is created in (defaults to [appName]).
  String directory;

  /// Platforms passed to `flutter create --platforms` (empty = Flutter default).
  List<String> platforms;

  /// Create `.github/workflows` to build an APK and send it to Telegram.
  bool usingGitHubAction;

  /// Run `git init` and make the first commit.
  bool initGit;

  /// Remote repository to push the first commit to (optional).
  String remoteUrl;

  /// Open the project in VS Code at the end.
  bool openInVSCode;

  /// State management of the project.
  StateManagement stateManagement;

  /// Custom template (GitHub URL, git URL, zip URL or folder). `null` uses
  /// the official Thunder-Template branch for [stateManagement].
  String? template;

  /// Use the template bundled with Thunder instead of downloading it.
  bool offline;

  /// Creates the model.
  AppDataModel({
    this.appName = '',
    this.organization = 'com.example',
    this.title = '',
    this.directory = '',
    this.platforms = const [],
    this.usingGitHubAction = false,
    this.initGit = true,
    this.remoteUrl = '',
    this.openInVSCode = false,
    this.stateManagement = StateManagement.getx,
    this.template,
    this.offline = false,
  });

  /// The application id (Android package name / iOS bundle id).
  String get packageName => '$organization.$appName';

  @override
  String toString() {
    return 'AppDataModel{appName: $appName, organization: $organization, title: $title, state: ${stateManagement.name}}';
  }
}
