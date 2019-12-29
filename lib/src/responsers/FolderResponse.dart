part of route_provider;

class FolderResponse<T extends Map<dynamic, dynamic>> extends Response<T> {
  String folderpath;

  /// set by routeprovider while init
  String urlPattern;
  bool recursive;

  FolderResponse(this.folderpath, {this.recursive = false}) : super() {
    if (folderpath.endsWith('/') == false) {
      folderpath += '/';
    }
  }

  @override
  Future response(HttpRequest request, T vars) async {
    final path = request.uri.path;
    String filePath;

    if (recursive == true) {
      filePath = folderpath + path.replaceFirst(urlPattern, '');
    } else {
      final _filename = path.split('/').last;
      final _testPathFilename = urlPattern + _filename;
      if (_testPathFilename == path) {
        filePath = folderpath + path.replaceFirst(urlPattern, '');
      }
    }

    if (filePath == null) {
      throw RouteError(HttpStatus.notFound, 'Not found');
    }

    filePath = filePath.replaceAll('/', Platform.pathSeparator);
    filePath = filePath.replaceAll(Platform.pathSeparator + Platform.pathSeparator, Platform.pathSeparator);

    await FileResponse(filePath).response(request, vars);
  }
}
