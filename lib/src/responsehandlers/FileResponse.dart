part of route_provider;

class FileResponse extends ResponseHandler {
  String filename;

  FileResponse(this.filename) : super();

  @override
  Future response(HttpRequest request, Map vars) async {
    String fileName = this.filename;
    var file = new File(fileName);
    bool fileExists = await file.exists();
    if (fileExists == true) {
      String mimeType = mime(fileName);
      if (mimeType == null) {
        mimeType = 'text/plain; charset=UTF-8';
      }
      request.response.headers.add(HttpHeaders.contentTypeHeader, mimeType);

      StreamConsumer<List<int>> streamConsumer = request.response;
      file.openRead().pipe(streamConsumer).then((streamConsumer) {
        streamConsumer.close();
      });
    } else {
      throw new RouteError(HttpStatus.notFound, "Not found");
    }
  }
}
