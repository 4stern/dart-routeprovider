part of route_provider;

class Router {
  HttpServer server;
  String basePath;
  StreamSubscription subscription;
  Map<String, RouteBundle> _calls = Map<String, RouteBundle>();
  Map<String, RouteBundle> _folders = Map<String, RouteBundle>();

  Router(this.server, {this.basePath = ''});

  void route({String url, Controller controller, Response responser, Auth auth}) {
    ArgumentError.checkNotNull(url);

    if (controller == null) {
      controller = EmptyRouteController();
    }
    if (auth == null) {
      auth = StaticAuth(authed: true);
    }

    String realPath = this.basePath + url;
    if (responser is FolderResponse) {
      String normalizedRealPath = realPath.replaceAll('*', '');
      responser.urlPattern = normalizedRealPath;
      responser.recursive = realPath.contains('/**');

      _folders[normalizedRealPath] = RouteBundle(controller, responser, auth);
    } else {
      _calls[realPath] = RouteBundle(controller, responser, auth);
    }
  }

  void start() {
    if (subscription == null) {
      subscription = server.listen(this.handleRequest);
    }
  }

  void stop() {
    server.close();
    subscription.cancel();
    subscription = null;
  }

  void clear() {
    _calls.clear();
    _folders.clear();
  }

  Future handleRequest(HttpRequest request) async {
    String path = request.uri.path;
    RouteBundle bundle;
    Map params;

    // direct cancels
    if (path.contains('..') || path.contains(':')) {
      _send404(request);
    } else {
      if (bundle == null) {
        bundle = checkForDirectUrls(path);
      }

      if (bundle == null) {
        bundle = checkForFolders(path);
      }

      if (bundle == null) {
        ParameterizedResult result = checkForParameterizedUrl(path);
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
    List<String> possibleFolders = _folders.keys.where((folderPaths) => path.startsWith(folderPaths) == true && path.endsWith('/') == false).toList();
    if (possibleFolders.isEmpty) {
      return null;
    } else if (possibleFolders.length == 1) {
      return _folders[possibleFolders.first];
    } else {
      String moreSpecializedElement = possibleFolders.reduce((value, element) {
        return value.split('/').length > element.split('/').length ? value : element;
      });
      return _folders[moreSpecializedElement];
    }
  }

  ParameterizedResult checkForParameterizedUrl(String path) {
    String url;
    Map params;

    for (var key in _calls.keys) {
      Map compareResult = this._compareUrlPattern(path, key);
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
      AuthResponse authResponse = await bundle.auth.isAuthed(request, params);
      if (authResponse != null) {
        var templateVars = await bundle.controller.execute(request, params, authResponse: authResponse);
        await bundle.responser.response(request, templateVars);
      } else {
        throw RouteError(HttpStatus.unauthorized, "Auth failed");
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
    List<String> requestedUrl = url.split("/");
    List<String> patternUrl = urlPattern.split("/");
    int countIdent = 0;
    bool matched = false;
    Map<String, String> matchedResult = Map<String, String>();

    if (requestedUrl.length == patternUrl.length) {
      for (int i = 0; i < requestedUrl.length; i++) {
        bool doublePoint = patternUrl[i].startsWith(":");
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
