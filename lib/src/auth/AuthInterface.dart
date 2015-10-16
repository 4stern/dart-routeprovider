part of route_provider;

abstract class Auth {
    Future<bool> isAuthed(HttpRequest request, Map params);
}

class StaticAuth implements Auth {
    bool authed = false;
    StaticAuth({this.authed : false});
    Future<bool> isAuthed(HttpRequest request, Map params) async => this.authed;
}
