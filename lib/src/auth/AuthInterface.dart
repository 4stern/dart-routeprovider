part of route_provider;

abstract class Auth {
    Future<bool> isAuthed();
}

class StaticAuth implements Auth {
    bool authed = false;
    StaticAuth({this.authed : false});
    Future<bool> isAuthed() async => this.authed;
}
