part of route_provider;

abstract class Controller<T extends Map<dynamic, dynamic>> {
  Controller();

  dynamic _testJson(String data) {
    try {
      return json.decode(data);
    } on FormatException catch (error, stacktrace) {
      /* catching the expected Exeption with none-json data
             * therewhile no error messages logged */
      error.toString(); /* only for suppress warnings */
      stacktrace.toString(); /* only for suppress warnings */
      return null;
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      return null;
    }
  }

  Map _testQuery(String query) {
    try {
      if (query.startsWith("?")) {
        query = query.replaceFirst("?", "");
      }
      if (query.startsWith("&")) {
        query = query.replaceFirst("&", "");
      }

      // Split the query into pieces
      List<List<String>> pieces = query.split("&").map((e) => e.split("=")).toList();

      // Convert the pieces into a map
      Map params = <dynamic, dynamic>{};
      pieces.forEach((List<String> piece) => params[piece[0]] = piece[1]);
      return params;
    } on FormatException catch (error, stacktrace) {
      error.toString(); /* only for suppress warnings */
      stacktrace.toString(); /* only for suppress warnings */
      return null;
    } catch (error, stacktrace) {
      error.toString(); /* only for suppress warnings */
      stacktrace.toString(); /* only for suppress warnings */
      return null;
    }
  }

  Future<String> _getData(HttpRequest request) async {
    Completer<String> _completer = Completer();
    String bodyData = "";
    utf8.decoder.bind(request).listen((stream) {
      bodyData += stream;
    }, onDone: () {
      _completer.complete(bodyData);
    }, onError: (Object error) {
      throw RouteError(HttpStatus.internalServerError, 'Internal Server Error');
    });
    return _completer.future;
  }

  Future<Map> getBodyData(HttpRequest request) async {
    String body = await this._getData(request);
    Map data;
    //testing stream format
    dynamic t = this._testJson(body);
    if (t is Map) {
      data = t;
    }
    if (data == null) {
      data = this._testQuery(body);
    }
    return data;
  }

  Future<T> execute(HttpRequest request, Map params, {AuthResponse authResponse});
}

/// Empty implementation of RouteController
class EmptyRouteController extends Controller<Map<dynamic, dynamic>> {
  @override
  Future<Map<dynamic, dynamic>> execute(HttpRequest request, Map params, {AuthResponse authResponse}) async {
    return Map<dynamic, dynamic>();
  }
}
