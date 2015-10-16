part of route_provider;

abstract class RouteController {
    RouteController();

    Map _testJson(String data) {
        try {
            return JSON.decode(data);

        } on FormatException catch(error, stacktrace) {
            /* catching the expected Exeption with none-json data
             * therewhile no error messages logged */
             stacktrace = stacktrace;/* only for suppress warnings */
             error = error;/* only for suppress warnings */
            return null;

        } catch (error, stacktrace) {
            print(error.toString());
            print(stacktrace.toString());
            return null;
        }
    }

    Map _testQuery(String query) {
        try {

            if(query.startsWith("?")){
                query = query.replaceFirst("?","");
            }
            if(query.startsWith("&")){
                query = query.replaceFirst("&","");
            }

            // Split the query into pieces
            List pieces = query.split("&").map((e) => e.split("="));

            // Convert the pieces into a map
            Map params = {};
            pieces.forEach((piece) => params[piece[0]] = piece[1]);
            return params;
        } on FormatException catch(error, stacktrace) {
            stacktrace = stacktrace;/* only for suppress warnings */
            error = error;/* only for suppress warnings */
            return null;

        } catch (error, stacktrace) {
            stacktrace = stacktrace;/* only for suppress warnings */
            error = error;/* only for suppress warnings */
            return null;
        }
    }
    Future<String> _getData(HttpRequest request) async {
        Completer _completer = new Completer();
        String bodyData = "";
        request.transform(UTF8.decoder).listen((stream){
            bodyData += stream;
        },
        onDone:(){
            _completer.complete(bodyData);
        },
        onError:(error){
            throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Internal Server Error');
        });
        return _completer.future;
    }

    Future<Map> getBodyData(HttpRequest request) async {
        String body = await this._getData(request);
        Map data;
        //testing stream format
        data = this._testJson(body);
        if (data == null) {
            data = this._testQuery(body);
        }
        return data;
    }

    Future<Map> execute(HttpRequest request, Map params, {AuthResponse authResponse: null}) async  {
        Map map = new Map();
        return map;
    }
}

/**
 * Empty implementation of RouteController
 */
class EmptyRouteController extends RouteController {}
