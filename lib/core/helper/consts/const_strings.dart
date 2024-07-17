import '../extensions/string_extensions.dart';

class ConstStrings {
  // create singleton for ConstStrings
  static final ConstStrings instance = ConstStrings._internal();

  factory ConstStrings() => instance;

  ConstStrings._internal();

  String repoGetXUrl =
      "https://github.com/abdAlftahSalem/flutter_getx_template.git";

  String repoBloCUrl =
      "https://github.com/abdAlftahSalem/flutter_getx_template.git";

  String controllerGetX(String controllerName) {
    controllerName = controllerName.toCamelCaseFirstLetterForEachWord();
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

  String viewGetX(String viewName) {
    String viewClassName = viewName.toCamelCaseFirstLetterForEachWord();

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

  String buildApkFileWorkFlow() {
    return """
name: Build Flutter APK and send it to telegram ...
on:
  push:
    branches:
      - master

jobs:
  build_apk:
    name: Build Flutter (Android APK)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - uses: actions/setup-java@v1
        with:
          java-version: '12.x'
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - name: Build Universal APK
        run: flutter build apk --release --split-per-abi --tree-shake-icons
      - name: send apk as a message
        uses: appleboy/telegram-action@master
        with:
          to: \${{ secrets.MESSAGEID }}
          token: \${{ secrets.BOTTOKEN }}
          message: |
            New Version Below . The apk commit is : \${{ github.event.inputs.message }}
          document: \${{ github.workspace }}/build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk

    """;
  }
}
