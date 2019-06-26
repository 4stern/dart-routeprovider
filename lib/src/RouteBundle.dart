part of route_provider;

class RouteBundle {
  RouteController controller;
  ResponseHandler responser;
  Auth auth;
  RouteBundle(this.controller, this.responser, this.auth);
}
