import 'package:route_provider/route_provider.dart';
import 'dart:io';

import 'controllers/RouteControllerError.dart';

class Auths {
    Auth allowed = new StaticAuth(authed: true);
    Auth denyed = new StaticAuth(authed: false);
}

class Controllers {
    Controller notFoundError = new RouteControllerError(HttpStatus.notFound);
    Controller internalServerError = new RouteControllerError(HttpStatus.internalServerError);
}

class Responsers {
    Response json = new JsonResponse();
    Response none = new NoneResponse();
}

class Client {
    HttpClient client = new HttpClient();
    String host;
    int port;

    Client({this.host, this.port});

    Future<HttpClientResponse> get(String path) async {
        return await (await client.get(host, port, path)).close();
    }
}

class TestContext {
    Auths auth = new Auths();
    Controllers controller = new Controllers();
    Responsers responser = new Responsers();
    Router router;
    Client client;

    final int port;
    TestContext({this.port = 4040});

    Future<HttpServer> createServer({InternetAddress adress, int port}) async {
        InternetAddress _adress = adress != null ? adress : InternetAddress.loopbackIPv4;
        int _port = port != null ? port : this.port;
        return await HttpServer.bind(_adress, _port);
    }

    Router createRouter(HttpServer server) {
        router = new Router(server);
        return router;
    }

    Future<Router> init() async {
        createRouter(await createServer());
        client = new Client(
            host: router.server.address.host,
            port: router.server.port
        );
        return router;
    }
}
