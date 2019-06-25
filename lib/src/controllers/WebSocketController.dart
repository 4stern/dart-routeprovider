part of route_provider;

abstract class WebSocketController extends RouteController {
  @override
  Future<Map> execute(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    try {
      WebSocketTransformer.upgrade(request).then((WebSocket websocket) {
        websocket.listen((message) {
          listener(websocket, message);
        });
      });
      return new Map();
    } on RouteError catch (error, stacktrace) {
      print(error.getMessage().toString());
      print(stacktrace.toString());
      throw error;
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      throw new RouteError(
          HttpStatus.internalServerError, 'Internal Server Error');
    }
  }

  /// must be overwritten
  void listener(WebSocket websocket, message) {}
}
