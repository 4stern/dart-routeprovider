part of route_provider;

class RedirectResponse extends ResponseHandler {
  String routeUrl;
  int httpStatus;

  RedirectResponse(this.routeUrl, this.httpStatus) : super();

  @override
  Future response(HttpRequest request, Map vars) async {
    return request.response.redirect(Uri.parse(this.routeUrl), status: this.httpStatus);
  }
}
