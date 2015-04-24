part of route_provider;

abstract class RouteController {
    RouteController();

    Future<Map> execute(HttpRequest request, Map params) {
        var completer = new Completer();
        Map map = new Map();
        completer.complete(map);
        return completer.future;
    }
}

/**
 * Empty implementation of RouteController
 */
class RouteControllerEmpty extends RouteController {}