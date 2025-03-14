import 'package:thunder_cli/features/init_project/clone_repo_and_setup_project.dart';
import 'package:thunder_cli/features/init_project/get_project_data.dart';
import 'package:thunder_cli/features/init_project/models/app_data_model.dart';

class InitProject {
  static Future<void> initProject() async {
    try {
      final AppDataModel appInfo = GetProjectData.getProjectData();

      await CloneRepoAndSetupProject.cloneAndSetupProject(
        dirName: appInfo.appName,
        appInfo: appInfo,
      );
    } catch (e) {
      print('😅 An error occurred: $e');
    }
  }
}
