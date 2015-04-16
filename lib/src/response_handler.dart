part of route_provider;

abstract class ResponseHandler {
    ResponseHandler();

    String response(HttpRequest request, Map vars) {
        return '';
    }
}