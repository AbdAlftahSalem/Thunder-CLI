import 'models/variable_model.dart';

class GetVariablesData {
  static List<VariableModel> getVariables(List vars) {
    List<VariableModel> variablesCollection = [];
    for (var i in vars) {
      variablesCollection.add(VariableModel.fromMap(i));
    }
    if (variablesCollection.isNotEmpty) {
      print(
          "\n\n✅ Read ${variablesCollection.length} variables from collection ...\n");
      for (int i = 0; i < variablesCollection.length; ++i) {
        print(
            "$i - ${variablesCollection[i].key} : ${variablesCollection[i].value}");
      }
    }
    return variablesCollection;
  }
}
