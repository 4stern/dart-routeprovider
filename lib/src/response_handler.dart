part of route_provider;

abstract class ResponseHandler {
    String filename;

    ResponseHandler(this.filename);

    String response(HttpRequest request, Map vars) {
        return '';
    }
}