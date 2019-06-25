library route_provider;

import 'dart:async';
import 'dart:io';
import 'package:route_provider/route_provider.dart';

class RouteControllerError extends RouteController {
  RouteControllerError();

  @override
  Future<Map> execute(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.notFound, "ERROR");
  }
}

class APIController extends RestApiController {

  @override
  Future<Map> onGet(HttpRequest request, Map params,
      {AuthResponse authResponse}) async {
    throw new RouteError(HttpStatus.internalServerError, 'Not supported');
  }
}

class MyAuth implements Auth {
  bool authed = false;
  MyAuth({this.authed = false});

  @override
  Future<AuthResponse> isAuthed(HttpRequest request, Map params) async =>
      this.authed ? new AuthResponse() : null;
}

Future main() async {
  HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);

  print('listening on localhost, port ${server.port}');

  //start webserver
  new RouteProvider(server)
    ..route(
        url: '/',
        responser: new FileResponse("docroot/home.html"),
        auth: new MyAuth(authed: true))
    ..route(
        url: '/',
        responser: new FolderResponse("docroot/"),
        auth: new MyAuth(authed: true))
    ..route(
        url: '/img',
        responser: new FolderResponse("docroot/assets/img"),
        auth: new MyAuth(authed: true))
    ..route(
        url: '/assets/**',
        responser: new FolderResponse("docroot/assets/"),
        auth: new MyAuth(authed: true))
    ..route(
        url: '/js/**',
        responser: new FolderResponse("docroot/code/"),
        auth: new MyAuth(authed: true))
    ..route(
        url: '/error',
        controller: new RouteControllerError(),
        responser: new FileResponse("docroot/home.html"),
        auth: new MyAuth(authed: true))
    ..route(
        url: '/error2',
        controller: new APIController(),
        responser: new FileResponse("docroot/home.html"),
        auth: new MyAuth(authed: true))
    ..route(
        url: '/noauth',
        controller: new APIController(),
        responser: new FileResponse("docroot/home.html"),
        auth: new MyAuth(authed: false))
    ..start();

  //perform more tests here

  // provider.stop();
}
