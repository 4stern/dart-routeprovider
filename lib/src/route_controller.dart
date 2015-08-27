part of route_provider;

abstract class RouteController {
    RouteController();

    Future<Map> execute(HttpRequest request, Map params) async  {
        Map map = new Map();
        return map;
    }
}

/**
 * Empty implementation of RouteController
 */
class EmptyRouteController extends RouteController {}
