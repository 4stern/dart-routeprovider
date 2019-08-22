part of route_provider;

class StatusOnlyResponse extends NoneResponse {
  int status;
  String message;

  StatusOnlyResponse(this.status, {this.message = ''}) : super();

  @override
  Future response(HttpRequest request, Map vars) async {
    request.response.statusCode = this.status;
    request.response.write(this.message);
    await request.response.flush();
    await request.response.close();
  }
}
