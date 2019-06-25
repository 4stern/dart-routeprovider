part of route_provider;

abstract class RestApiController extends RouteController {
  RestApiController();

  Future<Map> onOptions(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<Map> onGet(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<Map> onHead(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<Map> onPost(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<Map> onPut(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<Map> onDelete(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<Map> onTrace(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<Map> onConnect(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  Future<Map> onDefault(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.internalServerError, 'Not supported');
  }

  @override
  Future<Map> execute(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    try {
      String method = request.method.toUpperCase();
      switch (method) {
        case "OPTIONS":
          return await this
              .onOptions(request, params, authResponse: authResponse);

        case "GET":
          return await this.onGet(request, params, authResponse: authResponse);

        case "HEAD":
          return await this.onHead(request, params, authResponse: authResponse);

        case "POST":
          return await this.onPost(request, params, authResponse: authResponse);

        case "PUT":
          return await this.onPut(request, params, authResponse: authResponse);

        case "DELETE":
          return await this
              .onDelete(request, params, authResponse: authResponse);

        case "TRACE":
          return await this
              .onTrace(request, params, authResponse: authResponse);

        case "CONNECT":
          return await this
              .onConnect(request, params, authResponse: authResponse);

        default:
          return await this
              .onDefault(request, params, authResponse: authResponse);
      }
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
}
