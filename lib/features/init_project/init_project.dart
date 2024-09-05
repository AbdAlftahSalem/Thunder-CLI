import '../../core/models/app_data_model.dart';
import 'clone_repo_and_setup_project.dart';
import 'get_project_data.dart';

class InitProject {
  static Future<void> initProject() async {
    try {
      final AppDataModel appInfo = GetProjectData.getProjectData();

      CloneRepoAndSetupProject.cloneAndSetupProject(
        dirName: appInfo.appName,
        appInfo: appInfo,
      );
    } catch (e) {
      print('😅 An error occurred: $e');
    }
  }
}
