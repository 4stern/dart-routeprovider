part of route_provider;

class RouteBundle {
  Controller controller;
  Response responser;
  Auth auth;
  RouteBundle(this.controller, this.responser, this.auth);
}
