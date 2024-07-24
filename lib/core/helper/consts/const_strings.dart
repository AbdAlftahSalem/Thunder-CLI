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

  String repo(String controllerName) {
    controllerName = controllerName.toCamelCaseFirstLetterForEachWord();
    return '''
import '../../../../core/networking/api_call_status.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/base_client.dart';

class ${controllerName}Repo {
  Future<ApiResult> getHomeData() async {
    ApiResult apiResult = ApiResult();
    try {
      apiResult = await BaseClient.safeApiCall(
        "url",
        RequestType.get,
      );
      apiResult.apiCallStatus = ApiCallStatus.success;

      return apiResult;
    } catch (e) {
      return ApiResult.error(apiCallStatus: ApiCallStatus.error);
    }
  }
}

''';
  }

  String controllerGetX(String controllerName) {
    controllerName = controllerName.toCamelCaseFirstLetterForEachWord();
    return '''
import 'package:get/get.dart';

import 'package:get/get.dart';

import '../../../core/networking/api_call_status.dart';
import '../../../core/networking/api_result.dart';
import '../data/repo/${controllerName.toLowerCase()}_repo.dart';

class ${controllerName}Controller extends GetxController {
  ${controllerName}Repo ${controllerName.toLowerCase()}Repo;
  ${controllerName}Controller({required this.${controllerName.toLowerCase()}Repo});
  late ApiResult apiResult;

  // api call status
  ApiCallStatus apiCallStatus = ApiCallStatus.holding;

  // getting data from api
  getData() async {
    apiCallStatus = ApiCallStatus.loading;
    update();
    apiResult = await homeRepo.getHomeData();
    apiResult.handelRequest(
      success: (apiResult) {
        print("Success Request ...");
      },
      error: (apiResult) {
        print("Fail Request ...");
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

import '../logic/${viewName.toLowerCase()}_controller.dart';

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
