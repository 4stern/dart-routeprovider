library route_provider;

import 'dart:async';
import 'dart:io';
import 'package:route_provider/route_provider.dart';

class RouteControllerError extends Controller {
  RouteControllerError();

  @override
  Future<Map> execute(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.notFound, "ERROR");
  }
}

class APIController extends RestApiController {}

Future main() async {
  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);

  print('listening on localhost, port ${server.port}');

  //start webserver
  new Router(server)
    ..route(
        url: '/',
        responser: new FileResponse("docroot/home.html"),
        auth: new StaticAuth(authed: true))
    ..route(
        url: '/',
        responser: new FolderResponse("docroot/"),
        auth: new StaticAuth(authed: true))
    ..route(
        url: '/img',
        responser: new FolderResponse("docroot/assets/img"),
        auth: new StaticAuth(authed: true))
    ..route(
        url: '/assets/**',
        responser: new FolderResponse("docroot/assets/"),
        auth: new StaticAuth(authed: true))
    ..route(
        url: '/js/**',
        responser: new FolderResponse("docroot/code/"),
        auth: new StaticAuth(authed: true))
    ..route(
        url: '/error',
        controller: new RouteControllerError(),
        responser: new FileResponse("docroot/home.html"),
        auth: new StaticAuth(authed: true))
    ..route(
        url: '/error2',
        controller: new APIController(),
        responser: new FileResponse("docroot/home.html"),
        auth: new StaticAuth(authed: true))
    ..route(
        url: '/noauth',
        controller: new APIController(),
        responser: new FileResponse("docroot/home.html"),
        auth: new StaticAuth(authed: false))
    ..start();

  //perform more tests here

  // provider.stop();
}
