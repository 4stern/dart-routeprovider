part of route_provider;

class StatusOnlyResponse extends NoneResponse {
  int status;
  String message;

  StatusOnlyResponse(this.status, {this.message = ''}) : super();

  @override
  Future response(HttpRequest request, Map vars) async {
    throw RouteError(this.status, this.message);
  }
}
