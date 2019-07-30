part of route_provider;

abstract class WebSocketController extends Controller<Map<dynamic, dynamic>> {
  @override
  Future<Map<dynamic, dynamic>> execute(HttpRequest request, Map params, {AuthResponse authResponse}) async {
    try {
      WebSocket websocket = await WebSocketTransformer.upgrade(request);
      websocket.listen((dynamic message) {
        listener(websocket, message);
      });
      return Map<dynamic, dynamic>();
    } on RouteError catch (error, stacktrace) {
      print(error.getMessage().toString());
      print(stacktrace.toString());
      rethrow;
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      throw new RouteError(HttpStatus.internalServerError, 'Internal Server Error');
    }
  }

  /// must be overwritten
  void listener(WebSocket websocket, dynamic message) {}
}
