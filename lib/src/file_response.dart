part of route_provider;

class FileResponse extends ResponseHandler {
    String contentType = "text/plain";

    FileResponse(String filename) : super(filename);

    String response(HttpRequest request, Map vars) {
        var file = new File(this.filename);
        file.exists().then((ex){
            if(ex == true){
                Future<String> finishedReading = file.readAsString(encoding: UTF8);
                finishedReading.then((template) {
                    String ct = this.contentType;

                    if (this.filename.endsWith('.js')) {
                        ct = "application/javascript";
                    } else if (this.filename.endsWith('.css')) {
                        ct = "text/css";
                    }

                    request.response.headers.add(HttpHeaders.CONTENT_TYPE, ct);
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