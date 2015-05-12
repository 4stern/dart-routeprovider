library route_provider;

import 'dart:io';
import 'package:route_provider/route_provider.dart';
import 'dart:async';

class RouteControllerError extends RouteController {
    RouteControllerError();

    Future<Map> execute(HttpRequest request, Map params) async  {
        throw new RouteError(HttpStatus.NOT_FOUND,"ERROR");
    }

}

void main() async {

    HttpServer server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040);

    print('listening on localhost, port ${server.port}');

    //start webserver
    new RouteProvider(server, {
        "defaultRoute":"/",
        "staticContentRoot":"/docroot"
    })
    ..route({
        "url": "/",
        "controller": new RouteControllerEmpty(),
        "response": new FileResponse("docroot/home.html")
    })
    ..route({
        "url": "/error",
        "controller": new RouteControllerError(),
        "response": new FileResponse("docroot/home.html")
    })
    ..start();
}