class AppDataModel {
  String appName, packageName, stateManagement;

  AppDataModel({
    this.appName = '',
    this.packageName = '',
    this.stateManagement = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'stateManagement': stateManagement,
    };
  }

  factory AppDataModel.fromJson(Map<String, dynamic> map) {
    return AppDataModel(
      appName: map['appName'] ?? "",
      packageName: map['packageName'] ?? "",
      stateManagement: map['stateManagement'] ?? "",
    );
  }
}
