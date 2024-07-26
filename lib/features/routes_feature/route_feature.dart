import 'add_in_app_router.dart';
import 'add_in_route_file.dart';

class RouteFeature {
  /// Setup route file and folder and add route feature in files [featureName]
  static void setRoutes(String featureName) {
    print("*****************************************************");
    AddInAppRouter().addRouteInAppRoute(featureName);
    AddInRouteFile.addInRouteFile(featureName);
  }
}
