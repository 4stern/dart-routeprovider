import "package:test/test.dart";
import 'dart:io';
import 'package:route_provider/route_provider.dart';
import '../TestContext/TestContext.dart';

void main() {

    TestContext context = new TestContext(port: 4040);
    RouteProvider routeProvider;

    setUpAll(() async {
        routeProvider = await context.init();
        routeProvider.start();
    });

    setUp(() {
        routeProvider.clear();
    });

    tearDownAll(() {
        routeProvider.stop();
    });

    test('If the controller in a route return a notFoundError, the server delivers a 404 status', () async {
        String path = '/test';
        routeProvider.route(
            url: path,
            controller: context.controller.notFoundError,
            responser: context.responser.none,
            auth: context.auth.allowed
        );

        HttpClientResponse response = await context.get(path);

        expect(response.statusCode, equals(HttpStatus.notFound));
    });

    test('If the auth in a route do not allow the access, the server delivers a 401 status', () async {
        String path = '/test';
        routeProvider.route(
            url: path,
            controller: context.controller.notFoundError,
            responser: context.responser.none,
            auth: context.auth.denyed
        );

        HttpClientResponse response = await context.get(path);

        expect(response.statusCode, equals(HttpStatus.unauthorized));
    });
}
