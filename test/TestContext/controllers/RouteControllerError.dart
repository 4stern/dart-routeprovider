import 'package:route_provider/route_provider.dart';
import 'dart:io';

class RouteControllerError extends Controller {
  int httpStatus;
  RouteControllerError(this.httpStatus);

  @override
  Future<Map> execute(HttpRequest request, Map params, {AuthResponse authResponse}) async {
    throw RouteError(httpStatus, 'ERROR');
  }
}
