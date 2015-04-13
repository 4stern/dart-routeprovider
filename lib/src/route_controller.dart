part of routeprovider;

abstract class RouteController {
    RouteController();

    Future<Map> execute(Map params) {
        var completer = new Completer();
        Map map = new Map();
        completer.complete(map);
        return completer.future;
    }
}