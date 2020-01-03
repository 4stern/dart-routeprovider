part of route_provider;

class FileResponse<T extends Map<dynamic, dynamic>> extends Response<T> {
  String filename;

  FileResponse(this.filename) : super();

  @override
  Future response(HttpRequest request, T vars) async {
    final fileName = filename;
    var file = File(fileName);
    final fileExists = await file.exists();
    if (fileExists == true) {
      var mimeType = mime(fileName);
      mimeType ??= getContentType();

      request.response.headers.add(HttpHeaders.contentTypeHeader, mimeType);

      StreamConsumer<List<int>> streamConsumer = request.response;
      await file.openRead().cast<List<int>>().pipe(streamConsumer).then<void>((dynamic streamConsumer) {
        return streamConsumer.close();
      });
    } else {
      throw RouteError(HttpStatus.notFound, 'Not found');
    }
  }
}
