import 'add_in_app_router.dart';
import 'add_in_route_file.dart';

class RouteFeature {
  String nameFolder;

  RouteFeature({required this.nameFolder});

  void setRoutes() {
    print("*****************************************************");
    AddInAppRouter(nameFolder: nameFolder).addRouteInAppRoute();
    AddInRouteFile(nameFolder: nameFolder).addInRouteFile();
  }
}
