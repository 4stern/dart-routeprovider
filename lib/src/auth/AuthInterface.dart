part of route_provider;

class AuthResponse {}

abstract class Auth {
  Future<AuthResponse> isAuthed(HttpRequest request, Map params);
}

class StaticAuth implements Auth {
  bool authed;
  StaticAuth({this.authed});

  @override
  Future<AuthResponse> isAuthed(HttpRequest request, Map params) async => this.authed ? new AuthResponse() : null;
}
