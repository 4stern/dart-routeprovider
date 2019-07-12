part of route_provider;

class StaticAuthResponse implements AuthResponse {}

class StaticAuth implements Auth {
  bool authed;
  StaticAuth({this.authed});

  @override
  Future<AuthResponse> isAuthed(HttpRequest request, Map params) async => this.authed ? StaticAuthResponse() : null;
}
