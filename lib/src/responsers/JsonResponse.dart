part of route_provider;

class JsonResponse<T extends Map<dynamic, dynamic>> extends Response<T> {
  JsonResponse() : super();

  @override
  String getContentType() {
    return ContentType('application', 'json', charset: 'utf-8').toString();
  }

  @override
  Future response(HttpRequest request, T responseData) {
    try {
      request.response.headers.add(HttpHeaders.contentTypeHeader, getContentType());
      responseData ??= <dynamic, dynamic>{} as T;
      try {
        final outputString = json.encode(responseData);
        request.response.write(outputString);
        request.response.close();
      } catch(e) {
        throw RouteError(HttpStatus.internalServerError, 'Converting data to json failed');
      };
    } on RouteError catch (routeError, stacktrace) {
      print(routeError.getMessage());
      print(stacktrace.toString());
      rethrow;
    } catch (error, stacktrace) {
      print(error.toString());
      print(stacktrace.toString());
      throw RouteError(HttpStatus.internalServerError, 'Internal Server Error');
    }
    return null;
  }
}
