import '../../localization_feature/models/from_to_language_model.dart';

class AppDataModel {
  String appName, packageName, stateManagement;
  bool usingGitHubAction, usingFlavors;
  LocalizationModel? localizationModel;

  AppDataModel({
    this.appName = '',
    this.packageName = '',
    this.stateManagement = '',
    this.usingGitHubAction = true,
    this.usingFlavors = true,
    this.localizationModel,
  });

  Map<String, dynamic> toJson() {
    return {
      'app_name': appName,
      'package_name': packageName,
      'state_management': stateManagement,
      'using_github_action': usingGitHubAction,
      'using_flavors': usingFlavors,
      'localization_model': localizationModel?.toMap(),
    };
  }

  factory AppDataModel.fromJson(Map<String, dynamic> map) {
    print("HERE : ${map['localization_model']}");
    return AppDataModel(
      appName: map['app_name'] ?? "",
      packageName: map['package_name'] ?? "",
      stateManagement: map['state_management'] ?? "",
      usingGitHubAction: map['using_github_action'] ?? "",
      usingFlavors: map['using_flavors'] ?? "",
      localizationModel:
          LocalizationModel.fromMap(map['localization_model']),
    );
  }
}

class LocalizationModel {
  String baseLanguage, lastWordTranslated;
  List<ToLanguages>? toLanguages;

  LocalizationModel({
    this.baseLanguage = '',
    this.lastWordTranslated = '',
    this.toLanguages,
  });

  Map<String, dynamic> toMap() {
    return {
      'base_language': baseLanguage,
      'last_word_translated': lastWordTranslated,
      'to_languages': (toLanguages ?? []).map((e) => e.toMap()).toList(),
    };
  }

  factory LocalizationModel.fromMap(Map<String, dynamic> map) {
    return LocalizationModel(
      baseLanguage: map['base_language'],
      lastWordTranslated: map['last_word_translated'],
      toLanguages: (map['to_languages'] as List)
          .map((e) => ToLanguages.fromMap(e))
          .toList(),
    );
  }
}
