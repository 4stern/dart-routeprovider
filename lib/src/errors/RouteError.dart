part of route_provider;

class RouteError extends Error {
  final int _httpStatus;
  final String _httpMessage;

  RouteError(this._httpStatus, this._httpMessage);

  int getStatus() => _httpStatus;
  String getMessage() => _httpMessage;
}
