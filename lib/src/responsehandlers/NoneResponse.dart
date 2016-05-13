part of route_provider;

class NoneResponse extends ResponseHandler {
    NoneResponse() : super();

    Future response(HttpRequest request, Map vars) {
        return null;
    }
}
