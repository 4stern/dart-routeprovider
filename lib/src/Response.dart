part of route_provider;

abstract class Response {
  Response();

  Future response(HttpRequest request, Map vars) async {}

  String getContentType() {
    return new ContentType("text", "plain", charset: "utf-8").toString();
  }
}
