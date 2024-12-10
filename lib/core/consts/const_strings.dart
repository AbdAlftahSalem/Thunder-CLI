import 'package:thunder_cli/features/localization_feature/models/from_to_language_model.dart';

import '../../features/create_api_model/setup_request_data.dart';
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

  /// Build Repo class using dioHelper and return Future<ApiResult>
  String repo(
    String repoName, {
    String repoParameter = '',
    requestType = 'get',
    url = "ApiConstants.todosApiUrl",
  }) {
    repoName = repoName.toCamelCaseFirstLetterForEachWord();

    return '''
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/base_client.dart';
import '../../../../core/networking/enums_networking.dart';
import '../../../../helper/constants/api_constants.dart';
${repoParameter.isNotEmpty ? "import '../models/${repoParameter.split(" ")[0]}.dart';" : ""}

class ${repoName}Repo {
  DioHelper dioHelper;

  ${repoName}Repo(this.dioHelper);

  ${repoFunction(repoName, url: url, requestType: requestType, repoParameter: repoParameter)}
}
''';
  }

  String repoFunction(String repoName,
      {String repoParameter = '',
      String requestType = 'get',
      String url = "ApiConstants.todosApiUrl"}) {
    repoName = repoName.toCamelCaseFirstLetterForEachWord();

    String newRepoParameter =
        repoParameter.split(" ")[0].toCamelCaseFirstLetterForEachWord();
    newRepoParameter += " ${repoParameter.split(" ").last}";

    return """
Future<ApiResult> $requestType${url.split("/").last.replaceAll("ApiConstants.", "").toCamelCaseFirstLetterForEachWord()}Data($newRepoParameter) async {
    ApiResult apiResult = ApiResult();
    try {
      apiResult = await dioHelper.safeApiCall(
        $url,
        ${SetupRequestData.getRequestType(requestType)},
      );
      apiResult.apiCallStatus = ApiCallStatus.success;

      return apiResult;
    } catch (e) {
      return ApiResult.error(apiCallStatus: ApiCallStatus.error);
    }
  }""";
  }

  /// Build base controller using GetX with main method to get data from API
  String controllerGetX(String controllerName,
      {String repoMethodName = "", String bodyModel = ""}) {
    String controllerClassName =
        '${controllerName.toCamelCaseFirstLetterForEachWord()}Controller';
    String repoClassName =
        '${controllerName.toCamelCaseFirstLetterForEachWord()}Repo';
    String newRepoMethodName = "";

    if (repoMethodName.isEmpty) {
      newRepoMethodName =
          "${controllerName.toCamelCaseFirstLetterForEachWord().lowerCaseFirstLetter()}Repo.get${controllerName.toCamelCaseFirstLetterForEachWord()}Data()";
    } else {
      newRepoMethodName =
          "${repoClassName.lowerCaseFirstLetter()}.$repoMethodName($bodyModel)";
    }

    return '''
import 'package:get/get.dart';

import '../../../core/networking/api_result.dart';
import '../../../core/networking/enums_networking.dart';
${bodyModel.isEmpty ? "" : "import '../data/models/${controllerName.toLowerCase()}_body_model.dart';"}
import '../data/repo/${controllerName.toLowerCase()}_repo.dart';

class $controllerClassName extends GetxController {
  $repoClassName ${repoClassName.lowerCaseFirstLetter()};
  
  $controllerClassName({required this.${repoClassName.lowerCaseFirstLetter()}});
  
  late ApiResult apiResult;

  // getting data from api
  getData() async {
    apiResult.apiCallStatus = ApiCallStatus.loading;
    update();
    
    apiResult = await $newRepoMethodName;
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

  /// Build View with base code and link with controller to start build UI
  String viewGetX(String viewName) {
    String viewClassName = viewName.toCamelCaseFirstLetterForEachWord();

    return '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/widgets/custom_widgets/custom_text.dart';

import '../logic/${viewName.toLowerCase()}_controller.dart';

class ${viewClassName}View extends StatelessWidget {
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

  /// Add workflow to build APK file and send it to telegram using github action when push code on master branch
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

  // set up locale.dart
  String myLocale(FromToLanguageModel fromToLanguageModel) {
    String setupLanguages = """
{
        '${fromToLanguageModel.baseLanguage.substring(0, 2)}' : ${fromToLanguageModel.baseLanguage.substring(0, 2)}Language,
        ${fromToLanguageModel.toLanguages.map((e) => "'${e.languageDartFileName}' : ${e.languageName}Language,").toList().join("")}
      };
""";

    String setupLanguagesImports = """
import 'package:get/get.dart';
import './${fromToLanguageModel.baseLanguage.substring(0, 2)}_translation.dart';
${fromToLanguageModel.toLanguages.map((e) => "import './${e.languageDartFileName}_translation.dart';").toList().join("\n")}
""";

    return """
$setupLanguagesImports
class MyLocal implements Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      $setupLanguages
}

""";
  }
}
