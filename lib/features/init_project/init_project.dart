import 'package:thunder_cli/core/extensions/app_data_extesions.dart';

import 'clone_repo_and_setup_project.dart';
import 'get_project_data.dart';
import 'models/app_data_model.dart';

class InitProject {
  static Future<void> initProject() async {
    try {
      final AppDataModel appInfo = GetProjectData.getProjectData();

      await appInfo.saveModel();

      await CloneRepoAndSetupProject.cloneAndSetupProject(
        dirName: appInfo.appName,
        appInfo: appInfo,
      );

      await appInfo.saveModel();
    } catch (e) {
      print('😅 An error occurred: $e');
    }
  }
}
