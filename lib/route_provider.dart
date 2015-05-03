library route_provider;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:mime_type/mime_type.dart';

part 'src/route_controller.dart';
part 'src/response_handler.dart';
part 'src/errors/route_error.dart';

part 'src/responsehandlers/file_response.dart';

class RouteProvider {
    HttpServer server;
    Map cfg;
    Map<String, Map> routeControllers = new Map();
    String basePath = new File(Platform.script.toFilePath()).parent.path;

    RouteProvider(this.server, this.cfg);

    void route(Map routeConfig) {
        if (routeConfig.containsKey('url')) {
            String url = routeConfig["url"];
            this.routeControllers[url] = routeConfig;
        }
    }

    void start() {
        server.listen(this.handleRequest);
    }

    void handleRequest(HttpRequest request) async {
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
        if (this.routeControllers.containsKey(path)) {
            Map params = null;

            //get config of this route
            Map routeConfig = this.routeControllers[path];

            RouteController controller = routeConfig["controller"];
            ResponseHandler responseHandler = routeConfig["response"];

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
            for(var key in this.routeControllers.keys) {
                Map test = this.compareUrlPattern(path, key);
                if(test != null){
                    comparedUrlParams= test;
                    comparedUrl = key;
                    break;
                }
            };
            if(comparedUrlParams!=null){

                // found url
                //get config of this route
                Map routeConfig = this.routeControllers[comparedUrl];

                RouteController controller = routeConfig["controller"];
                ResponseHandler responseHandler = routeConfig["response"];

                //create vars for the template
                var templateVars = await controller.execute(request, comparedUrlParams);
                await responseHandler.response(request, templateVars);
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