library route_provider;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mime_type/mime_type.dart';

part 'src/route_controller.dart';
part 'src/response_handler.dart';
part 'src/errors/route_error.dart';
part 'src/responsehandlers/FileResponse.dart';
part 'src/responsehandlers/FolderResponse.dart';
part 'src/responsehandlers/JsonResponse.dart';
part 'src/responsehandlers/NoneResponse.dart';
part 'src/responsehandlers/RedirectResponse.dart';
part 'src/controllers/RestApiController.dart';
part 'src/controllers/WebSocketController.dart';
part 'src/auth/AuthInterface.dart';

class RouteBundle {
  RouteController controller;
  ResponseHandler responser;
  Auth auth;
  RouteBundle(this.controller, this.responser, this.auth);
}

class ParameterizedResult {
  RouteBundle bundle;
  Map params;
  ParameterizedResult({this.bundle, this.params});
}

class RouteProvider {
  HttpServer server;
  String basePath;

  Map<String, RouteBundle> _calls = new Map<String, RouteBundle>();
  Map<String, RouteBundle> _folders = new Map<String, RouteBundle>();

  RouteProvider(this.server, {this.basePath =''});

  void route(
      {String url,
      RouteController controller,
      ResponseHandler responser,
      Auth auth}) {
    ArgumentError.checkNotNull(url);

    if (controller == null) {
      controller = new EmptyRouteController();
    }
    if (auth == null) {
      auth = new StaticAuth(authed: true);
    }

    String realPath = this.basePath + url;
    if (responser is FolderResponse) {
      String normalizedRealPath = realPath.replaceAll('*', '');
      responser.urlPattern = normalizedRealPath;
      responser.recursive = realPath.contains('/**');

      _folders[normalizedRealPath] =
          new RouteBundle(controller, responser, auth);
    } else {
      _calls[realPath] = new RouteBundle(controller, responser, auth);
    }
  }

  void start() {
    server.listen(this.handleRequest);
  }

  void stop() {
    server.close();
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

  RouteBundle checkForDirectUrls(path) =>
      _calls.containsKey(path) ? _calls[path] : null;

  RouteBundle checkForFolders(path) {
    List<String> possibleFolders = _folders.keys
        .where((folderPaths) =>
            path.startsWith(folderPaths) == true && path.endsWith('/') == false)
        .toList();
    if (possibleFolders.isEmpty) {
      return null;
    } else if (possibleFolders.length == 1) {
      return _folders[possibleFolders.first];
    } else {
      String moreSpecializedElement = possibleFolders.reduce((value, element) {
        return value.split('/').length > element.split('/').length
            ? value
            : element;
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
      return new ParameterizedResult(bundle: _calls[url], params: params);
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

  void _executeResponse(
      HttpRequest request, Map params, RouteBundle bundle) async {
    try {
      AuthResponse authResponse = await bundle.auth.isAuthed(request, params);
      if (authResponse != null) {
        var templateVars = await bundle.controller
            .execute(request, params, authResponse: authResponse);
        await bundle.responser.response(request, templateVars);
      } else {
        throw new RouteError(HttpStatus.unauthorized, "Auth failed");
      }
    } on RouteError catch (routeError) {
      request.response.statusCode = routeError.getStatus();
      request.response
        ..write(routeError.getMessage())
        ..close();
      await new Future.value();
    } catch (error) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response
        ..write(error)
        ..close();
      await new Future.value();
    }
  }

  Map _compareUrlPattern(String url, String urlPattern) {
    List<String> requestedUrl = url.split("/");
    List<String> patternUrl = urlPattern.split("/");
    int countIdent = 0;
    bool matched = false;
    Map<String, String> matchedResult = new Map<String, String>();

    if (requestedUrl.length == patternUrl.length) {
      for (int i = 0; i < requestedUrl.length; i++) {
        bool doublePoint = patternUrl[i].startsWith(":");
        if (requestedUrl[i] == patternUrl[i] || doublePoint == true) {
          countIdent++;
          if (doublePoint == true) {
            matchedResult[patternUrl[i].substring(1).toString()] =
                requestedUrl[i].toString();
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
