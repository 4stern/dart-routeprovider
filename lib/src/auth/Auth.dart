part of route_provider;

abstract class Auth<A extends AuthResponse> {
  Future<A> isAuthed(HttpRequest request, Map params);
}

/// Used as Response from an [isAuthed] call to hold data of special implementations
/// Maybe informations about a user or environment.
abstract class AuthResponse {}
