part of route_provider;

abstract class ResponseHandler {
  ResponseHandler();

  Future response(HttpRequest request, Map vars) async {}
}
