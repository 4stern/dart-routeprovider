part of routeprovider;

abstract class ResponseHandler {
    String filename;

    ResponseHandler(this.filename);

    String response(HttpRequest request, Map vars) {
        return '';
    }
}