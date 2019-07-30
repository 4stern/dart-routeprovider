part of route_provider;

class NoneResponse<T extends Map<dynamic, dynamic>> extends Response<T> {
  NoneResponse() : super();

  @override
  Future response(HttpRequest request, T vars) async {
    return request.response.close();
  }
}
