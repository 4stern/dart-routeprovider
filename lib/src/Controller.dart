part of route_provider;

abstract class Controller<R extends Map<dynamic, dynamic>, A extends AuthResponse> {
  Controller();

  dynamic _testJson(String data) {
    try {
      return json.decode(data);
    } on FormatException catch (error, stacktrace) {
      /* catching the expected Exception with none-json data there while no error messages logged */
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
      if (query.startsWith('?')) {
        query = query.replaceFirst('?', '');
      }
      if (query.startsWith('&')) {
        query = query.replaceFirst('&', '');
      }

      // Split the query into pieces
      final pieces = query.split('&').map((e) => e.split('=')).toList();

      // Convert the pieces into a map
      final params = <dynamic, dynamic>{};
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
    final _completer = Completer<String>();
    var bodyData = '';
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
    final body = await _getData(request);
    Map data;
    //testing stream format
    dynamic t = _testJson(body);
    if (t is Map) {
      data = t;
    }
    data ??= _testQuery(body);
    return data;
  }

  Future<R> execute(HttpRequest request, Map params, {A authResponse});
}

/// Empty implementation of RouteController
class EmptyRouteController<R extends Map<dynamic, dynamic>, A extends AuthResponse> extends Controller<R, A> {
  @override
  Future<R> execute(HttpRequest request, Map params, {A authResponse}) async {
    return <dynamic, dynamic>{} as R;
  }
}
