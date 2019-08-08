part of route_provider;

class JsonResponse<T extends Map<dynamic, dynamic>> extends Response<T> {
  JsonResponse() : super();

  @override
  String getContentType() {
    return ContentType("application", "json", charset: "utf-8").toString();
  }

  @override
  Future response(HttpRequest request, T responseData) {
    try {
      request.response.headers.add(HttpHeaders.contentTypeHeader, getContentType());
      if (responseData != null) {
        String outputString = json.encode(responseData);
        print('JsonResponse -> ' + request.uri.toString() + '\n\t' + outputString);

        request.response.write(outputString);
        request.response.close();
      } else {
        throw RouteError(HttpStatus.internalServerError, 'Converting data to json failed');
      }
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
