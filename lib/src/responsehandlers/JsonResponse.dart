part of route_provider;

class JsonResponse extends ResponseHandler {
    JsonResponse() : super();

    Future response(HttpRequest request, Map vars) {
        try{
            if(vars!=null){
                String outputString = JSON.encode(vars);
                print('JsonResponse -> '+request.uri.toString()+'\n\t'+outputString);
                request.response.headers.contentType = new ContentType("application", "json", charset: "utf-8");
                request.response.write(outputString);
                request.response.close();
            } else {
                throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Converting data to json failed');
            }

        } on RouteError catch(routeError, stacktrace) {
            print(routeError.getMessage());
            print(stacktrace.toString());
            throw routeError;
        } catch (error, stacktrace) {
            print(error.toString());
            print(stacktrace.toString());
            throw new RouteError(HttpStatus.INTERNAL_SERVER_ERROR, 'Internal Server Error');
        }
        return null;
    }
}
