part of dart-routeprovider;

abstract class ResponseHandler {
    String filename;

    ResponseHandler(this.filename);

    String response(HttpRequest request, Map vars) {
        return '';
    }
}