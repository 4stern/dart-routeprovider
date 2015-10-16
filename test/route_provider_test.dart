library route_provider;

import 'dart:async';
import 'dart:io';
import 'package:route_provider/route_provider.dart';

class RouteControllerError extends RouteController {
    RouteControllerError();

    Future<Map> execute(HttpRequest request, Map params) async  {
        throw new RouteError(HttpStatus.NOT_FOUND,"ERROR");
    }
}

class APIController extends RestApiController {
    Future<Map> onGet(HttpRequest request, Map params) async {
        throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Not supported');
    }
}

class MyAuth implements Auth {
    bool authed = false;
    MyAuth({this.authed : false});
    Future<bool> isAuthed() async => this.authed;
}

Future main() async {

    HttpServer server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040);

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
