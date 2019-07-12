library route_provider;

import 'dart:async';
import 'dart:io';
import 'package:route_provider/route_provider.dart';

class RouteControllerError extends Controller {
  RouteControllerError();

  @override
  Future<Map> execute(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw RouteError(HttpStatus.notFound, "ERROR");
  }
}

class APIController extends RestApiController {}

Future main() async {
  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);

  print('listening on localhost, port ${server.port}');

  //start webserver
  Router(server)
    ..route(
        url: '/',
        responser: FileResponse("docroot/home.html"),
        auth: StaticAuth(authed: true))
    ..route(
        url: '/',
        responser: FolderResponse("docroot/"),
        auth: StaticAuth(authed: true))
    ..route(
        url: '/img',
        responser: FolderResponse("docroot/assets/img"),
        auth: StaticAuth(authed: true))
    ..route(
        url: '/assets/**',
        responser: FolderResponse("docroot/assets/"),
        auth: StaticAuth(authed: true))
    ..route(
        url: '/js/**',
        responser: FolderResponse("docroot/code/"),
        auth: StaticAuth(authed: true))
    ..route(
        url: '/error',
        controller: RouteControllerError(),
        responser: FileResponse("docroot/home.html"),
        auth: StaticAuth(authed: true))
    ..route(
        url: '/error2',
        controller: APIController(),
        responser: FileResponse("docroot/home.html"),
        auth: StaticAuth(authed: true))
    ..route(
        url: '/noauth',
        controller: APIController(),
        responser: FileResponse("docroot/home.html"),
        auth: StaticAuth(authed: false))
    ..start();

  //perform more tests here

  // provider.stop();
}
