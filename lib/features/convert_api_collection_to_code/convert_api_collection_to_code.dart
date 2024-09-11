import 'package:thunder_cli/core/models/request_model.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/extract_request_details.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/get_variables_data.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/read_file_path_and_data.dart';
import 'package:thunder_cli/features/convert_api_collection_to_code/set_routes_in_api_const.dart';

import '../../core/models/variable_model.dart';
import './build_repos_for_requests.dart';
import 'build_body_model_file.dart';
import 'build_controller_for_requests.dart';

/*
✅ 1- Build api const file ( for all routes in collection )
✅ 2- Build model body file if request has body data
✅ 3- Build model for every response request
✅ 4- Build repo file for request ( one repo can have multi repos function ( need name for every function ) )
✅ 5- Build controller file for request ( one controller can have multi function ( need name for every function ) )
*/

class ConvertApiCollectionToCode {
  static Future<void> convertApiCollectionToCode() async {
    // read collection data
    Map<String, dynamic> collectionData =
        await ReadFilePathAndData.readFilePathAndData();

    // extract variables
    List<VariableModel> variablesModel =
        GetVariablesData.getVariables(collectionData['variable']);

    // get all requests
    List<RequestModel> requests = ExtractRequestDetails.extractRequestDetails(
      collectionData: collectionData,
      variablesModel: variablesModel,
    );
    // 1- set routes in const API file
    requests = await SetRoutesInApiConst.setRoutesInApiConst(
      requests,
      variablesModel
          .firstWhere((element) => element.key.toLowerCase().contains("url"))
          .value,
    );

    // 2- Build model for request has body
    BuildBodyModelFile.buildBodyModelFile(requests);
    print("\n✅ Finish Build body models successfully ...");

    // 3- build response model for every request
    // for (var element in requests) {
    //   await CreateApiModel().createApiModel(requestModelParameter: element);
    // }

    // 4 - build repo for every request
    await BuildRepoForRequests.buildRepoForRequests(requests);

    // 5 - build controller for every request
    await BuildControllerForRequests.buildControllerForRequests(requests);

    print("\n✅ Finish read variables from collection successfully ...");
    print("\n✅ Finish extract requests from collection successfully ...");
    print("\n✅ Finish add routes in api_constants.dart ...");
    print("\n✅ Finish build body model for request has body ...");
    print("\n✅ Finish build response model ...");
    print("\n✅ Finish build repos ...");
    print("\n✅ Finish build controllers ...");
  }
}
