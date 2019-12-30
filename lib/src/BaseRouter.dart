part of route_provider;

class BaseRouter {
  HttpServer server;
  String basePath;
  StreamSubscription subscription;
  final Map<String, RouteBundle> _calls = {};
  final Map<String, RouteBundle> _folders = {};

  BaseRouter(this.server, {this.basePath = ''});

  void route({String url, Controller controller, Response responser, Auth auth}) {
    ArgumentError.checkNotNull(url);

    controller ??= EmptyRouteController();
    auth ??= StaticAuth(authed: true);

    final realPath = basePath + url;
    if (responser is FolderResponse) {
      final normalizedRealPath = realPath.replaceAll('*', '');
      responser.urlPattern = normalizedRealPath;
      responser.recursive = realPath.contains('/**');

      _folders[normalizedRealPath] = RouteBundle(controller, responser, auth);
    } else {
      _calls[realPath] = RouteBundle(controller, responser, auth);
    }
  }

  void start() {
    subscription ??= server.listen(handleRequest);
  }

  void stop() {
    server?.close();
    subscription?.cancel();
    subscription = null;
  }

  void clear() {
    _calls.clear();
    _folders.clear();
  }

  Future handleRequest(HttpRequest request) async {
    final path = request.uri.path;
    RouteBundle bundle;
    Map params;

    // direct cancels
    if (path.contains('..') || path.contains(':')) {
      _send404(request);
    } else {
      bundle ??= checkForDirectUrls(path);
      bundle ??= checkForFolders(path);

      if (bundle == null) {
        final result = checkForParameterizedUrl(path);
        if (result != null) {
          bundle = result.bundle;
          params = result.params;
        }
      }

      if (bundle != null) {
        await _executeResponse(request, params, bundle);
      } else {
        _send404(request);
      }
    }
  }

  RouteBundle checkForDirectUrls(String path) => _calls.containsKey(path) ? _calls[path] : null;

  RouteBundle checkForFolders(String path) {
    final possibleFolders = _folders.keys.where((folderPaths) => path.startsWith(folderPaths) == true && path.endsWith('/') == false).toList();
    if (possibleFolders.isEmpty) {
      return null;
    } else if (possibleFolders.length == 1) {
      return _folders[possibleFolders.first];
    } else {
      final moreSpecializedElement = possibleFolders.reduce((value, element) {
        return value.split('/').length > element.split('/').length ? value : element;
      });
      return _folders[moreSpecializedElement];
    }
  }

  ParameterizedResult checkForParameterizedUrl(String path) {
    String url;
    Map params;

    for (var key in _calls.keys) {
      final compareResult = _compareUrlPattern(path, key);
      if (compareResult != null) {
        params = compareResult;
        url = key;
        break;
      }
    }

    if (url != null) {
      return ParameterizedResult(bundle: _calls[url], params: params);
    } else {
      return null;
    }
  }

  void _send404(HttpRequest request) {
    //404 not found
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('Not found')
      ..close();
  }

  void _executeResponse(HttpRequest request, Map params, RouteBundle bundle) async {
    try {
      final authResponse = await bundle.auth.isAuthed(request, params);
      if (authResponse != null) {
        var templateVars = await bundle.controller.execute(request, params, authResponse: authResponse);
        await bundle.responser.response(request, templateVars);
      } else {
        throw RouteError(HttpStatus.unauthorized, 'Auth failed');
      }
    } on RouteError catch (routeError) {
      request.response.headers.add(HttpHeaders.contentTypeHeader, bundle.responser.getContentType());
      request.response.statusCode = routeError.getStatus();
      request.response.write(routeError.getMessage());
      await request.response.close();
    } catch (error) {
      request.response.headers.add(HttpHeaders.contentTypeHeader, bundle.responser.getContentType());
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write(error);
      await request.response.close();
    }
  }

  Map _compareUrlPattern(String url, String urlPattern) {
    final requestedUrl = url.split('/');
    final patternUrl = urlPattern.split('/');
    var countIdent = 0;
    var matched = false;
    final matchedResult = <String, String>{};

    if (requestedUrl.length == patternUrl.length) {
      for (var i = 0; i < requestedUrl.length; i++) {
        final doublePoint = patternUrl[i].startsWith(':');
        if (requestedUrl[i] == patternUrl[i] || doublePoint == true) {
          countIdent++;
          if (doublePoint == true) {
            matchedResult[patternUrl[i].substring(1).toString()] = requestedUrl[i].toString();
          }
        }
      }
      matched = countIdent == requestedUrl.length;
    }

    if (matched == true) {
      return matchedResult;
    } else {
      return null;
    }
  }
}