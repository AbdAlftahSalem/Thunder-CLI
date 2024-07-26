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
import '../../../../helper/constants/api_constants.dart';

class ${controllerName}Repo {
  DioHelper dioHelper;

  ${controllerName}Repo(this.dioHelper);

  Future<ApiResult> get${controllerName}Data() async {
    ApiResult apiResult = ApiResult();
    try {
      apiResult = await dioHelper.safeApiCall(
        ApiConstants.todosApiUrl,
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
    // TODO TODO TODO  : UPDATE THIS CODE ...
    return '''
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/networking/api_call_status.dart';
import '../../../core/networking/api_result.dart';
import '../data/repo/${controllerName.toLowerCase()}_repo.dart';

class ${controllerName.toCamelCaseFirstLetterForEachWord()}Controller extends GetxController {
  ${controllerName.toCamelCaseFirstLetterForEachWord()}Repo ${controllerName.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}Repo;
  
  ${controllerName.toCamelCaseFirstLetterForEachWord()}Controller({required this.${controllerName.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}Repo});
  
  late ApiResult apiResult;

  // getting data from api
  getData() async {
    apiResult.apiCallStatus = ApiCallStatus.loading;
    update();
    apiResult = await ${controllerName.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}Repo.get${controllerName.toCamelCaseFirstLetterForEachWord()}Data();
    apiResult.handelRequest(success: (apiResul){}, error: (apiResul){});
    update();
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

import '../../../helper/widgets/custom_widgets/custom_text.dart';

import '../logic/${viewName.toLowerCase()}_controller.dart';

class ${viewClassName}View extends GetView<${viewClassName}Controller> {
  const ${viewClassName}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<${viewClassName}Controller>(
        builder: (controller) {
          return const Center(
            child: CustomText(txt: "$viewClassName"),
          );
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
