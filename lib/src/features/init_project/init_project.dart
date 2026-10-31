import 'dart:io';

import 'package:args/args.dart';

import '../../core/services/console_service/console.dart';
import 'create_flutter_project.dart';
import 'get_project_data.dart';
import 'models/app_data_model.dart';
import 'open_project_in_vs_code.dart';
import 'publish_project_to_github.dart';
import 'set_up_github_action.dart';

/// `thunder init`: creates a new Flutter project (GetX, BLoC or Cubit).
class InitProject {
  /// Runs the command. Returns the process exit code.
  static Future<int> initProject(ArgResults args) async {
    final AppDataModel appInfo;
    try {
      appInfo = GetProjectData.getProjectData(args);
    } on ArgumentError catch (e) {
      Console.error('${e.message}');
      return 64;
    }

    Console.info('\n🔃 Thunder will initialize your app. Please wait ...\n');
    if (!await CreateFlutterProject.create(appInfo)) return 1;

    final root = Directory(appInfo.directory).absolute.path;
    if (appInfo.usingGitHubAction) {
      await SetUpGithubAction.setUpGithubAction(root);
    }
    if (appInfo.initGit) {
      await PublishProjectToGithub.publishProjectToGithub(root,
          remoteUrl: appInfo.remoteUrl);
    }
    if (appInfo.openInVSCode) {
      await OpenProjectInVSCode.openProjectInVSCode(root);
    }

    Console.info('''

⚡ ${appInfo.title} is ready (${appInfo.stateManagement.label}) 🎉

  cd ${appInfo.directory}
  flutter run

Next:
  thunder feature profile          # view + controller + repo + route
  thunder model --name post --url https://jsonplaceholder.typicode.com/posts
  thunder c_api --collection my_api.postman_collection.json
  thunder localization --from en --to ar
''');
    return 0;
  }
}
