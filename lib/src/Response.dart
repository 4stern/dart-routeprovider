part of route_provider;

abstract class Response<T extends Map<dynamic, dynamic>> {
  Response();

  Future response(HttpRequest request, T vars) async {}

  String getContentType() => ContentType('text', 'plain', charset: 'utf-8').toString();
}
