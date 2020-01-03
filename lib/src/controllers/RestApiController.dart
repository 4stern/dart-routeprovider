part of route_provider;

abstract class RestApiController<T extends Map<dynamic, dynamic>, K extends AuthResponse> extends Controller<T, K> {
  bool cors;
  List<String> corsOrigin = ['*'];
  List<String> corsMethods = ['GET', 'PUT', 'POST', 'DELETE', 'OPTIONS', 'CONNECT'];
  List<String> corsHeaders = ['Content-Type', 'Accept', 'X-Access-Token', 'X-Key'];

  RestApiController({this.cors = true});

  void setCorsHeaders(HttpRequest request) {
    request.response.headers.set('Access-Control-Allow-Origin', corsOrigin.join(','));
    request.response.headers.set('Access-Control-Allow-Methods', corsMethods.join(','));
    request.response.headers.set('Access-Control-Allow-Headers', corsHeaders.join(','));
  }

  Future<T> onOptions(HttpRequest request, Map params, {K authResponse}) async {
    if (cors) {
      return <dynamic, dynamic>{} as T;
    } else {
      throw RouteError(HttpStatus.internalServerError, 'Not supported');
    }
  }

  Future<T> onGet(HttpRequest request, Map params, {K authResponse}) async {
    throw RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<T> onHead(HttpRequest request, Map params, {K authResponse}) async {
    throw RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<T> onPatch(HttpRequest request, Map params, {K authResponse}) async {
    throw RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<T> onPost(HttpRequest request, Map params, {K authResponse}) async {
    throw RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<T> onPut(HttpRequest request, Map params, {K authResponse}) async {
    throw RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<T> onDelete(HttpRequest request, Map params, {K authResponse}) async {
    throw RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<T> onTrace(HttpRequest request, Map params, {K authResponse}) async {
    throw RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<T> onConnect(HttpRequest request, Map params, {K authResponse}) async {
    throw RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<T> onDefault(HttpRequest request, Map params, {K authResponse}) async {
    throw RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  @override
  Future<T> execute(HttpRequest request, Map params, {K authResponse}) async {
    try {
      if (cors) {
        setCorsHeaders(request);
      }
      final method = request.method.toUpperCase();
      switch (method) {
        case 'OPTIONS':
          return await onOptions(request, params, authResponse: authResponse);

        case 'GET':
          return await onGet(request, params, authResponse: authResponse);

        case 'HEAD':
          return await onHead(request, params, authResponse: authResponse);

        case 'PATCH':
          return await onPatch(request, params, authResponse: authResponse);

          case 'POST':
          return await onPost(request, params, authResponse: authResponse);

        case 'PUT':
          return await onPut(request, params, authResponse: authResponse);

        case 'DELETE':
          return await onDelete(request, params, authResponse: authResponse);

        case 'TRACE':
          return await onTrace(request, params, authResponse: authResponse);

        case 'CONNECT':
          return await onConnect(request, params, authResponse: authResponse);

        default:
          return await onDefault(request, params, authResponse: authResponse);
      }
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
}
