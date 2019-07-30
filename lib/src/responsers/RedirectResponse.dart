part of route_provider;

class RedirectResponse<T extends Map<dynamic, dynamic>> extends Response<T> {
  String routeUrl;
  int httpStatus;

  RedirectResponse(this.routeUrl, this.httpStatus) : super();

  @override
  Future response(HttpRequest request, T vars) async {
    return request.response.redirect(Uri.parse(this.routeUrl), status: this.httpStatus);
  }
}
