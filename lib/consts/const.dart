import '../extensions/string_extensions.dart';

class ConstStrings {
  // create singleton for ConstStrings
  static final ConstStrings instance = ConstStrings._internal();

  factory ConstStrings() => instance;

  ConstStrings._internal();

  String binding(String bindingName) {
    String bindingClassName = bindingName.toCamelCase();

    return '''
import 'package:get/get.dart';

import './${bindingName.toLowerCase()}_controller.dart';

class ${"${bindingClassName}Binding"} extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${bindingClassName}Controller>(
      () => ${bindingClassName}Controller(),
    );
  }
}
''';
  }

  String controller(String controllerName) {
    controllerName = controllerName.toCamelCase();
    return '''
import 'package:get/get.dart';

import '../../../../utils/constants.dart';
import '../../data/remote/api_call_status.dart';
import '../../data/remote/base_client.dart';

class ${controllerName}Controller extends GetxController {
  // hold data coming from api
  List<dynamic>? data;

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  // getting data from api
  getData() async {
    // *) perform api call
    await BaseClient.safeApiCall(
      Constants.todosApiUrl, // url
      RequestType.get, // request type (get,post,delete,put)
      onLoading: () {
        // *) indicate loading state
        apiCallStatus = ApiCallStatus.loading;
        update();
      },
      onSuccess: (response) {
        // api done successfully
        data = List.from(response.data);
        // *) indicate success state
        apiCallStatus = ApiCallStatus.success;
        update();
      },
      // if you don't pass this method base client
      // will automaticly handle error and show message to user
      onError: (error) {
        // show error message to user
        BaseClient.handleApiError(error);
        // *) indicate error status
        apiCallStatus = ApiCallStatus.error;
        update();
      },
    );
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
''';
  }

  String view(String viewName) {
    String viewClassName = viewName.toCamelCase();

    return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './${viewName.toLowerCase()}_controller.dart';

class ${viewClassName}View extends GetView<${viewClassName}Controller> {
  const ${viewClassName}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<${viewClassName}Controller>(
        builder: (controller) {
         return const Center(child: Text("${viewName}View"));
        },
      ),
    );
  }
}
    ''';
  }
}
