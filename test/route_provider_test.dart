library route_provider;

import 'dart:io';
import 'package:route_provider/route_provider.dart';

void main() {

    Map config = {
        "server" :{
            "port": 4040
        }
    };

    HttpServer server;

    void handleRequest(HttpServer server){
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
        ..start();
    }


    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, config["server"]["port"])
    .then((HttpServer server){
        server = server;
        handleRequest(server);
    })
    .catchError((e) => print(e.toString()));

}