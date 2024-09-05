import 'add_in_app_router.dart';
import 'add_in_route_file.dart';

class RouteFeature {
  /// Setup route file and folder and add route feature in files [featureName]
  static Future<void> setRoutes(String featureName) async {
    await AddInAppRouter.addRouteInAppRoute(featureName);
    await AddInRouteFile.addInRouteFile(featureName);
  }
}
