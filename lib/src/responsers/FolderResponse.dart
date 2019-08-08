part of route_provider;

class FolderResponse<T extends Map<dynamic, dynamic>> extends Response<T> {
  String folderpath;

  /// set by routeprovider while init
  String urlPattern;
  bool recursive;

  FolderResponse(this.folderpath, {this.recursive = false}) : super() {
    this.folderpath = folderpath;
    if (this.folderpath.endsWith('/') == false) {
      this.folderpath += '/';
    }
  }

  @override
  Future response(HttpRequest request, T vars) async {
    String path = request.uri.path;
    String filePath;

    if (recursive == true) {
      filePath = folderpath + path.replaceFirst(urlPattern, '');
    } else {
      String _filename = path.split('/').last;
      String _testPathFilename = urlPattern + _filename;
      if (_testPathFilename == path) {
        filePath = folderpath + path.replaceFirst(urlPattern, '');
      }
    }

    if (filePath == null) {
      throw RouteError(HttpStatus.notFound, "Not found");
    }

    filePath = filePath.replaceAll('/', Platform.pathSeparator);
    filePath = filePath.replaceAll(Platform.pathSeparator + Platform.pathSeparator, Platform.pathSeparator);

    FileResponse fr = FileResponse(filePath);
    await fr.response(request, vars);
  }
}
