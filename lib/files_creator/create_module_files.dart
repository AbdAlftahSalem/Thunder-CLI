import 'dart:convert';
import 'dart:io';

import './create_routes_files.dart';
import '../consts/const.dart';
import '../data/remote/base_client.dart';
import '../extensions/string_extensions.dart';
import '../services/create_folder_files.dart';

class CreateModuleFiles {
  bool withModel;

  CreateModuleFiles({this.withModel = false});

  void createFiles() {
    stdout.write("Enter your view name [ login / bottom_nav ] : ");
    final name = stdin.readLineSync();

    if (name == null || name.isEmpty) {
      print("Name name cannot be empty !!");
    } else {
      _generateFiles(name);
    }
  }

  _generateFiles(String name) {
    // set up modules folder
    _setupFoldersModule(name);

    // set up files module
    _setupFilesModule(name);

    // // reading routes file
    // RoutesCreator(nameFolder: name).addInRoutesFile();
    //
    // // Create routes for module
    // RoutesCreator(nameFolder: name).addInAppRoutesFile();

    if (withModel) {
      createModelFile();
    }

    print("Create module files successfully 🚀🚀");
  }

  void _setupFoldersModule(String name) {
    // create modules folder
    CreateFolderAndFiles()
        .createFolder('E:/Flutter new/crypto_new/lib/app/modules');

    // create home folder
    CreateFolderAndFiles().createFolder(
        'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}');

    // create binding folder
    CreateFolderAndFiles().createFolder(
        'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/binding');

    // controller folder
    CreateFolderAndFiles().createFolder(
        'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/controller');

    // create view folder
    CreateFolderAndFiles().createFolder(
        'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/view');

    // create model folder
    if (withModel) {
      CreateFolderAndFiles().createFolder(
          'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/model');
    }
  }

  void _setupFilesModule(String name) {
    // create home binding file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/binding/${name.toLowerCase()}_binding.dart',
      ConstStrings.instance.binding(name),
    );

    // create home controller file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/controller/${name.toLowerCase()}_controller.dart',
      ConstStrings.instance.controller(name.toCamelCase()),
    );

    // create home view file
    CreateFolderAndFiles().createFile(
      'E:/Flutter new/crypto_new/lib/app/modules/${name.toLowerCase()}/view/${name.toLowerCase()}_view.dart',
      ConstStrings.instance.view(name),
    );
  }

  Future<void> createModelFile() async {
    // set up model file
    var data = await _setupRequestData();

    if (data[0]) {
      BaseClient.safeApiCall(
        data[1]["url"],
        data[1]["type"],
        headers: data[1]["headers"],
        data: data[1]["body"],
        queryParameters: data[1]["params"],
        onSuccess: (res) {
          // check if data is Map
          if (res.data is Map) {
            // convert Map to class model
            final model = convertMapToClassModel(res.data, data[1]["name"]);
            print(model);
          } else {
            print("Data is not Map !!");
          }
        },
      );
    }
  }

  Future _setupRequestData() async {
    stdout.write(
        "Enter your model name [ user / product [ thund will add 'model' keyword ] ] : ");
    final name = stdin.readLineSync();

    if (name == null || name.isEmpty) {
      print("Name name cannot be empty !!");
      return (false, null);
    }

    stdout.write("Enter type of request [ get / post ] : ");
    RequestType type = _getRequestType(stdin.readLineSync() ?? "");

    stdout.write("Enter your full url : ");
    final url = stdin.readLineSync();

    if (url == null || url.isEmpty) {
      print("Url cannot be empty !!");
      return [false, null];
    }

    stdout.write("Enter your request body : ");
    Map body = jsonDecode(stdin.readLineSync() ?? "{}");

    stdout.write("Enter your request headers : ");
    Map headers = jsonDecode(stdin.readLineSync() ?? "{}");

    stdout.write("Enter your request params : ");
    Map params = jsonDecode(stdin.readLineSync() ?? "{}");

    return [
      true,
      {
        "name": name,
        "type": type,
        "url": url,
        "body": body,
        "headers": headers,
        "params": params,
      }
    ];
  }

  RequestType _getRequestType(String type) {
    if (type == "get") {
      return RequestType.get;
    } else if (type == "post") {
      return RequestType.post;
    } else {
      return RequestType.get;
    }
  }

  String convertMapToClassModel(Map data, String name) {
    String content = "class ${name.toCamelCase()}Model {\n";

    List<String> mapKeys = [];

    // add variables
    data.forEach((key, value) {
      if (value is String) {
        content += "  String? $key;\n";
      } else if (value is int) {
        content += "  int? $key;\n";
      } else if (value is double) {
        content += "  double? $key;\n";
      } else if (value is bool) {
        content += "  bool? $key;\n";
      } else if (value is List) {
        content += "  List? $key;\n";
      } else if (value is Map) {
        content +=
            "  ${name.toCamelCase()}Model? ${key.toString().toLowerCase()};\n";
        mapKeys.add(key);
      } else {
        content += "  dynamic $key;\n";
      }
    });

    // add optional constructor
    content += "\n  ${name.toCamelCase()}Model({\n";
    data.forEach((key, value) {
      content += "    this.$key,\n";
    });
    content += "  })\n";

    // add fromJson method
    content +=
        "\n\n  factory ${name.toCamelCase()}Model.fromJson(Map<String, dynamic> json) => ${name.toCamelCase()}Model(\n";
    data.forEach((key, value) {
      content += "    $key: json['$key'],\n";
    });

    // add toJson method
    content += "  );\n\n  Map<String, dynamic> toJson() => {\n";
    data.forEach((key, value) {
      content += "    '$key': $key,\n";
    });
    content += "  };\n\n}\n\n";

    // add map keys
    for (var key in mapKeys) {
      content += convertMapToClassModel(data[key], key);
    }

    return content;
  }
}
