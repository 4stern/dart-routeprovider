part of route_provider;

class FileResponse extends ResponseHandler {
    String filename;

    FileResponse(this.filename) : super();

    String response(HttpRequest request, Map vars) {
        String fileName = this.filename;
        var file = new File(fileName);
        file.exists().then((ex){
            if(ex == true){
                Future<String> finishedReading = file.readAsString(encoding: UTF8);
                finishedReading.then((template) {

                    String mimeType = mime(fileName);
                    if (mimeType == null) mimeType = 'text/plain; charset=UTF-8';

                    request.response.headers.add(HttpHeaders.CONTENT_TYPE, mimeType);
                    request.response.write(template);
                    request.response.close();
                });
            } else {
                request.response
                    ..statusCode = HttpStatus.NOT_FOUND
                    ..write('Not found')
                    ..close();
            }
        });
    }
}