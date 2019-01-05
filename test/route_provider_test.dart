library route_provider;

import 'dart:async';
import 'dart:io';
import 'package:route_provider/route_provider.dart';

class RouteControllerError extends RouteController {
    RouteControllerError();

    Future<Map> execute(HttpRequest request, Map params, {AuthResponse authResponse: null}) async  {
        throw new RouteError(HttpStatus.notFound,"ERROR");
    }
}

class APIController extends RestApiController {
    Future<Map> onGet(HttpRequest request, Map params, {AuthResponse authResponse: null}) async {
        throw new RouteError(HttpStatus.internalServerError, 'Not supported');
    }
}

class MyAuth implements Auth {
    bool authed = false;
    MyAuth({this.authed : false});
    Future<AuthResponse> isAuthed(HttpRequest request, Map params) async => this.authed ? new AuthResponse() : null;
}

Future main() async {

    HttpServer server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);

    print('listening on localhost, port ${server.port}');

    //start webserver
    RouteProvider provider = new RouteProvider(server, {
        "defaultRoute":"/",
        "staticContentRoot":"/docroot"
    })

    ..route(
        // url: "/",
        // controller: new EmptyRouteController(),
        responser: new FileResponse("docroot/home.html"),
        auth: new MyAuth(authed: true)
    )
    ..route(
        url: "/error",
        controller: new RouteControllerError(),
        responser: new FileResponse("docroot/home.html"),
        auth: new MyAuth(authed: true)
    )
    ..route(
        url: "/error2",
        controller: new APIController(),
        responser: new FileResponse("docroot/home.html"),
        auth: new MyAuth(authed: true)
    )
    ..route(
        url: "/noauth",
        controller: new APIController(),
        responser: new FileResponse("docroot/home.html"),
        auth: new MyAuth(authed: false)
    )
    ..start();

    //perform more tests here

    provider.stop();
}
