part of route_provider;

abstract class RestApiController extends RouteController {

    RestApiController();

    Future<Map> onOptions(HttpRequest request, Map params) async {
        throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Not supported');
    }
    Future<Map> onGet(HttpRequest request, Map params) async {
        throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Not supported');
    }
    Future<Map> onHead(HttpRequest request, Map params) async {
        throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Not supported');
    }
    Future<Map> onPost(HttpRequest request, Map params) async {
        throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Not supported');
    }
    Future<Map> onPut(HttpRequest request, Map params) async {
        throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Not supported');
    }
    Future<Map> onDelete(HttpRequest request, Map params) async {
        throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Not supported');
    }
    Future<Map> onTrace(HttpRequest request, Map params) async {
        throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Not supported');
    }
    Future<Map> onConnect(HttpRequest request, Map params) async {
        throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Not supported');
    }
    Future<Map> onDefault(HttpRequest request, Map params) async {
        throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Not supported');
    }

    Future<Map> execute(HttpRequest request, Map params) async {
        try {

            String method = request.method.toUpperCase();
            switch (method) {
                case "OPTIONS":
                    return await this.onOptions(request, params);

                case "GET":
                    return await this.onGet(request, params);

                case "HEAD":
                    return await this.onHead(request, params);

                case "POST":
                    return await this.onPost(request, params);

                case "PUT":
                    return await this.onPut(request, params);

                case "DELETE":
                    return await this.onDelete(request, params);

                case "TRACE":
                    return await this.onTrace(request, params);

                case "CONNECT":
                    return await this.onConnect(request, params);

                default:
                    return await this.onDefault(request, params);
            }

        } on RouteError catch (error, stacktrace) {
            print(error.getMessage().toString());
            print(stacktrace.toString());
            throw error;

        } catch (error, stacktrace) {
            print(error.toString());
            print(stacktrace.toString());
            throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Internal Server Error');
        }
    }
}
