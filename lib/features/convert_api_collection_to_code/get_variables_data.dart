import '../../core/models/variable_model.dart';

class GetVariablesData {
  static List<VariableModel> getVariables(List vars) {
    List<VariableModel> variablesCollection = [];
    for (var i in vars) {
      variablesCollection.add(VariableModel.fromMap(i));
    }
    if (variablesCollection.isNotEmpty) {
      print(
          "✅ Read ${variablesCollection.length} variables from collection ...");
      for (var element in variablesCollection) {
        print("${element.key} : ${element.value}\n");
      }
    }
    return variablesCollection;
  }
}
