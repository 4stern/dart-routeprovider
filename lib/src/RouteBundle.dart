part of route_provider;

class RouteBundle<R extends Map<dynamic, dynamic>, A extends AuthResponse> {
  Auth<A> auth;
  Controller<R, A> controller;
  Response<R> responser;


  RouteBundle(this.controller, this.responser, this.auth);
}
