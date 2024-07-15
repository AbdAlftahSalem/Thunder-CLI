class AppDataModel {
  String appName, packageName, stateManagement;
  bool usingGitHubAction, usingFlavors;

  AppDataModel({
    this.appName = '',
    this.packageName = '',
    this.stateManagement = '',
    this.usingGitHubAction = true,
    this.usingFlavors = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'stateManagement': stateManagement,
      'usingGitHubAction': usingGitHubAction,
      'usingFlavors': usingFlavors,
    };
  }

  factory AppDataModel.fromJson(Map<String, dynamic> map) {
    return AppDataModel(
      appName: map['appName'] ?? "",
      packageName: map['packageName'] ?? "",
      stateManagement: map['stateManagement'] ?? "",
      usingGitHubAction: map['usingGitHubAction'] ?? "",
      usingFlavors: map['usingFlavors'] ?? "",
    );
  }
}
