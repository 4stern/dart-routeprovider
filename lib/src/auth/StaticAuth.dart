part of route_provider;

class StaticAuthResponse implements AuthResponse {}

class StaticAuth implements Auth<StaticAuthResponse> {
  bool authed;
  StaticAuth({this.authed});

  @override
  Future<StaticAuthResponse> isAuthed(HttpRequest request, Map params) async => authed ? StaticAuthResponse() : null;
}
