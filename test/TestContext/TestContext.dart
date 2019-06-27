import 'package:route_provider/route_provider.dart';
import 'dart:io';

import 'controllers/RouteControllerError.dart';

class Auths {
    Auth allowed = new StaticAuth(authed: true);
    Auth denyed = new StaticAuth(authed: false);
}

class Controllers {
    RouteController notFoundError = new RouteControllerError(HttpStatus.notFound);
    RouteController internalServerError = new RouteControllerError(HttpStatus.internalServerError);
}

class Responsers {
    ResponseHandler json = new JsonResponse();
    ResponseHandler none = new NoneResponse();
}

class TestContext {
    Auths auth = new Auths();
    Controllers controller = new Controllers();
    Responsers responser = new Responsers();
    RouteProvider routeProvider;
    HttpClient client = new HttpClient();

    final int port;
    TestContext({this.port = 4040});

    Future<HttpServer> createServer({InternetAddress adress, int port}) async {
        InternetAddress _adress = adress != null ? adress : InternetAddress.loopbackIPv4;
        int _port = port != null ? port : this.port;
        return await HttpServer.bind(_adress, _port);
    }

    RouteProvider createRouter(HttpServer server) {
        routeProvider = new RouteProvider(server);
        return routeProvider;
    }

    Future<RouteProvider> init() async {
        return createRouter(await createServer());
    }

    Future<HttpClientResponse> get(String path) async {
        if (routeProvider != null) {
            HttpClientRequest request = await client.get(routeProvider.server.address.host, routeProvider.server.port, path);
            return await request.close();
        } else {
            throw new StateError('Router not created');
        }
    }


}
