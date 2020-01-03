part of route_provider;

class UrlController {
  String url;
  String controllerName;

  UrlController(this.url, this.controllerName);
}

class Router<R extends Map<dynamic, dynamic>, A extends AuthResponse> extends BaseRouter<R, A> {
  final _routes = <UrlController>[];
  int _urlLenght = 0;
  int _controllerNameLength = 0;
  bool disableLogging;

  Router(HttpServer server, {String basePath = '', this.disableLogging = false}) : super(server, basePath: basePath);

  @override
  Future<void> start() async {
    super.start();
    if (!disableLogging) {
      _printRoutes();
    }
    print('server started at ${server.address.host}:${server.port}');
  }

  String _controllerName(Controller controller) {
    return controller != null ? controller.toString().split('\'')[1] : '';
  }

  void _printRoutes() {
    print('Created Routes\n');
    print('${"-- Route ".padRight(_urlLenght + 5, "-")}${"-- Controller ".padRight(_controllerNameLength + 2, "-")}');
    _routes.forEach((UrlController urlController) {
      print('   ${urlController.url.padRight(_urlLenght + 2)} ${urlController.controllerName.padRight(_controllerNameLength + 2)}');
    });
    print('');
  }

  @override
  void route({String url, Controller<R, A> controller, Response<R> responser, Auth<A> auth}) {
    final controllerName = _controllerName(controller);
    _routes.add(UrlController(url, controllerName));
    if (controllerName.length > _controllerNameLength) {
      _controllerNameLength = controllerName.length;
    }
    if (url.length > _urlLenght) {
      _urlLenght = url.length;
    }
    super.route(url: url, controller: controller, responser: responser, auth: auth);
  }
}
