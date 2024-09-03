import '../../core/consts/folder_paths.dart';
import '../../core/models/request_model.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';
import '../create_api_model/build_model_file.dart';

class BuildBodyModelFile {
  static void buildBodyModelFile(List<RequestModel> requests) async {
    for (var element in requests) {
      if (element.body.isNotEmpty) {

        String requestBodyModel = BuildModelFile.convertMapToClassModel(
            name: "${element.modelName}_body", response: element.body);

        await FolderAndFileService.createFile(
          FolderPaths.instance
              .modelFile("${element.modelName}_body", element.featureName),
          requestBodyModel,
          showMessageWhenCreate: false,
        );
      }
    }
  }
}
