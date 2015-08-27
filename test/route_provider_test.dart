library route_provider;

import 'dart:io';
import 'package:route_provider/route_provider.dart';

void main() async {

    HttpServer server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4040);

    print('listening on localhost, port ${server.port}');

    //start webserver
    new RouteProvider(server, {
        "defaultRoute":"/",
        "staticContentRoot":"/docroot"
    })
    ..route(
        // url: "/",
        // controller: new EmptyRouteController(),
        responser: new FileResponse("docroot/home.html")
    )
    ..start();
}
