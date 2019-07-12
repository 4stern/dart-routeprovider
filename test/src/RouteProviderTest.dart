import "package:test/test.dart";
import 'dart:io';
import 'package:route_provider/route_provider.dart';
import '../TestContext/TestContext.dart';

void main() {

    TestContext context = TestContext(port: 4040);
    Router router;

    setUpAll(() async {
        router = await context.init();
        router.start();
    });

    setUp(() async {
        await router.clear();
    });

    tearDownAll(() {
        router.stop();
    });

    group('Responsers set ContentType', () {
        group('JSON-Responser set "application/json"', () {
            test('normal case', () async {
                String path = '/test1';
                router.route(
                    url: path,
                    responser: context.responser.json,
                );
                HttpClientResponse response = await context.client.get(path);
                expect(response.headers.contentType.mimeType, equals('application/json'));
            });
            test('error from controller', () async {
                String path = '/test2';
                router.route(
                    url: path,
                    controller: context.controller.notFoundError,
                    responser: context.responser.json,
                    auth: context.auth.allowed
                );
                HttpClientResponse response = await context.client.get(path);
                expect(response.headers.contentType.mimeType, equals('application/json'));
            });
            test('error from auth', () async {
                String path = '/test3';
                router.route(
                    url: path,
                    responser: context.responser.json,
                    auth: context.auth.allowed
                );
                HttpClientResponse response = await context.client.get(path);
                expect(response.headers.contentType.mimeType, equals('application/json'));
            });
        });
    });

    group('Controller errors', () {
        test('If a controller return a notFoundError, the server delivers a 404 status', () async {
            String path = '/test4';
            router.route(
                url: path,
                controller: context.controller.notFoundError,
                responser: context.responser.none,
                auth: context.auth.allowed
            );

            HttpClientResponse response = await context.client.get(path);

            expect(response.statusCode, equals(HttpStatus.notFound));
            expect(response.contentLength, equals(-1));
            expect(response.headers.contentType.mimeType, equals('text/plain'));
        });
        test('If the auth in a route do not allow the access, the server delivers a 401 status', () async {
            String path = '/test5';
            router.route(
                url: path,
                controller: context.controller.notFoundError,
                responser: context.responser.none,
                auth: context.auth.denyed
            );

            HttpClientResponse response = await context.client.get(path);

            expect(response.statusCode, equals(HttpStatus.unauthorized));
            expect(response.contentLength, equals(-1));
            expect(response.headers.contentType.mimeType, equals('text/plain'));
        });
    });




}
