part of route_provider;

class StatusOnlyResponse extends NoneResponse {
  int status;
  String message;

  StatusOnlyResponse(this.status, {this.message = ''}) : super();

  @override
  Future response(HttpRequest request, Map vars) async {
    request.response.statusCode = status;
    request.response.write(message);
    await request.response.flush();
    await request.response.close();
  }
}
