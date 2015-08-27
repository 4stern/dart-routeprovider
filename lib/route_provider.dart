library route_provider;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mime_type/mime_type.dart';

part 'src/route_controller.dart';
part 'src/response_handler.dart';
part 'src/errors/route_error.dart';
part 'src/responsehandlers/file_response.dart';
part 'src/responsehandlers/JsonResponse.dart';
part 'src/controllers/RestApiController.dart';

class RouteProvider {
    HttpServer server;
    Map cfg;
    Map<String, RouteController> controllers = new Map();
    Map<String, ResponseHandler> responsers = new Map();
    String basePath = new File(Platform.script.toFilePath()).parent.path;

    RouteProvider(this.server, this.cfg);

    void route({
        String url: "/",
        RouteController controller,
        ResponseHandler responser
    }) {
        if (controller == null) {
            controller = new EmptyRouteController();
        }
        this.controllers[url] = controller;
        this.responsers[url] = responser;
    }

    void start() {
        server.listen(this.handleRequest);
    }

    void stop() {
        server.close();
    }

    Future handleRequest(HttpRequest request) async {
        String path = request.uri.path;

        // direct cancels
        if (path.contains('..') || path.contains(':')) {
            //404 not found
            request.response
                ..statusCode = HttpStatus.NOT_FOUND
                ..write('Not found')
                ..close();
        }

        // route has a config?
        if (this.controllers.containsKey(path)) {
            Map params = null;

            RouteController controller = this.controllers[path];
            ResponseHandler responseHandler = this.responsers[path];

            //create vars for the template
            try{
                var templateVars = await controller.execute(request, params);
                await responseHandler.response(request, templateVars);

            } on RouteError catch(routeError) {
                request.response.statusCode = routeError.getStatus();
                request.response
                    ..write(routeError.getMessage())
                    ..close();

            } catch (error) {
                request.response.statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
                request.response
                    ..write(error)
                    ..close();
            }
        } else {

            //try to handle urls with inner-vars
            String comparedUrl = null;
            Map comparedUrlParams = null;
            for(var key in this.controllers.keys) {
                Map test = this.compareUrlPattern(path, key);
                if(test != null){
                    comparedUrlParams= test;
                    comparedUrl = key;
                    break;
                }
            };
            if(comparedUrlParams!=null){

                // found url
                RouteController controller = this.controllers[comparedUrl];
                ResponseHandler responseHandler = this.responsers[comparedUrl];

                //create vars for the template
                try{
                    var templateVars = await controller.execute(request, comparedUrlParams);
                    await responseHandler.response(request, templateVars);

                } on RouteError catch(routeError) {
                    print("route_rpvoder: routeError");
                    print(routeError.getMessage());
                    request.response.statusCode = routeError.getStatus();
                    request.response
                        ..write(routeError.getMessage())
                        ..close();

                } catch (error) {
                    print("route_rpvoder: error");
                    print(error);
                    request.response.statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
                    request.response
                        ..write(error)
                        ..close();
                }
            } else {

                //try to find the file with the default file-response-handler
                if (this.cfg.containsKey('staticContentRoot')) {
                    String filePath = basePath + this.cfg['staticContentRoot'] + path;

                    filePath = filePath.replaceAll('/', Platform.pathSeparator);
                    filePath = filePath.replaceAll(Platform.pathSeparator+Platform.pathSeparator, Platform.pathSeparator);

                    try {
                        FileResponse fr = new FileResponse(filePath);
                        fr.response(request, {});
                    } catch (exception) {
                        //404 not found
                        request.response
                            ..statusCode = HttpStatus.NOT_FOUND
                            ..write('Not found')
                            ..close();
                    }
                } else {
                    //404 not found
                    request.response
                        ..statusCode = HttpStatus.NOT_FOUND
                        ..write('Not found')
                        ..close();
                }
            }
        }
    }

    Map compareUrlPattern(String url, String urlPattern){
        List requestedUrl = url.split("/");
        List patternUrl = urlPattern.split("/");
        int countIdent = 0;
        bool matched = false;
        Map<String, String> matchedResult = new Map<String, String>();

        if (requestedUrl.length == patternUrl.length) {
            for (int i=0; i<requestedUrl.length; i++) {
                bool doublePoint = patternUrl[i].startsWith(":");
                if ( requestedUrl[i] == patternUrl[i] || doublePoint==true ) {
                    countIdent++;
                    if(doublePoint==true){
                        matchedResult[patternUrl[i].substring(1)] = requestedUrl[i];
                    }
                }
            }
            matched = countIdent == requestedUrl.length;
        }
        if(matched == true){
            return matchedResult;
        } else {
            return null;
        }
    }
}
