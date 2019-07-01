part of route_provider;

class NoneResponse extends Response {
  NoneResponse() : super();

  @override
  Future response(HttpRequest request, Map vars) async {
    return request.response.close();
  }
}
