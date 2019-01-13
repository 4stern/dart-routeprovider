part of route_provider;

class NoneResponse extends ResponseHandler {
  NoneResponse() : super();

  @override
  Future response(HttpRequest request, Map vars) {
    return null;
  }
}
