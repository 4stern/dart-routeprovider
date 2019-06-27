import 'package:route_provider/route_provider.dart';
import 'dart:io';

class RouteControllerError extends RouteController {
    int httpStatus;
    RouteControllerError(this.httpStatus);

    @override
    Future<Map> execute(HttpRequest request, Map params, {AuthResponse authResponse}) async {
        throw new RouteError(httpStatus, "ERROR");
    }
}
