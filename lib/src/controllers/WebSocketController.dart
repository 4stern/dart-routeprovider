part of route_provider;

abstract class WebSocketController extends Controller<Map<dynamic, dynamic>> {
  @override
  Future<Map<dynamic, dynamic>> execute(HttpRequest request, Map params, {AuthResponse authResponse}) async {
    try {
      final websocket = await WebSocketTransformer.upgrade(request);
      websocket.listen((dynamic message) {
        listener(websocket, message);
      });
      return <dynamic, dynamic>{};
    } on RouteError catch (error, stacktrace) {
      print(error.getMessage().toString());
      print(stacktrace.toString());
      rethrow;
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      throw RouteError(HttpStatus.internalServerError, 'Internal Server Error');
    }
  }

  void listener(WebSocket websocket, dynamic message) {}
}
