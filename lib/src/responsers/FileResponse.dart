part of route_provider;

class FileResponse extends Response {
  String filename;

  FileResponse(this.filename) : super();

  @override
  Future response(HttpRequest request, Map vars) async {
    String fileName = this.filename;
    var file = File(fileName);
    bool fileExists = await file.exists();
    if (fileExists == true) {
      String mimeType = mime(fileName);
      if (mimeType == null) {
        mimeType = getContentType();
      }
      request.response.headers.add(HttpHeaders.contentTypeHeader, mimeType);

      StreamConsumer<List<int>> streamConsumer = request.response;
      await file.openRead().cast<List<int>>().pipe(streamConsumer).then<void>((dynamic streamConsumer) {
        return streamConsumer.close();
      });
    } else {
      throw RouteError(HttpStatus.notFound, "Not found");
    }
  }
}
