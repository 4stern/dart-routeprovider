import 'dart:async';
import 'dart:io';
import 'package:route_provider/route_provider.dart';

class RouteControllerError extends Controller {
  RouteControllerError();

  @override
  Future<Map> execute(HttpRequest request, Map params, {AuthResponse authResponse}) async {
    throw RouteError(HttpStatus.notFound, 'ERROR');
  }
}

class APIController extends RestApiController {
  @override
  Future<Map> onGet(HttpRequest request, Map params, {AuthResponse authResponse}) async {
    throw RouteError(HttpStatus.internalServerError, 'Not supported');
  }
}

class MyAuth implements Auth {
  bool authed = false;
  MyAuth({this.authed = false});

  @override
  Future<AuthResponse> isAuthed(HttpRequest request, Map params) async => authed ? StaticAuthResponse() : null;
}

Future main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4040);

  final router = Router(server)
    ..route(url: '/', responser: FileResponse('docroot/home.html'), auth: MyAuth(authed: true))
    ..route(url: '/', responser: FolderResponse('docroot/'), auth: MyAuth(authed: true))
    ..route(url: '/img', responser: FolderResponse('docroot/assets/img'), auth: MyAuth(authed: true))
    ..route(url: '/assets/**', responser: FolderResponse('docroot/assets/'), auth: MyAuth(authed: true))
    ..route(url: '/js/**', responser: FolderResponse('docroot/code/'), auth: MyAuth(authed: true))
    ..route(url: '/error', controller: RouteControllerError(), responser: FileResponse('docroot/home.html'), auth: MyAuth(authed: true))
    ..route(url: '/error2', controller: APIController(), responser: FileResponse('docroot/home.html'), auth: MyAuth(authed: true))
    ..route(url: '/noauth', controller: APIController(), responser: FileResponse('docroot/home.html'), auth: MyAuth(authed: false));
  await router.start();

  print('listening on localhost, port ${server.port}');
}
