part of route_provider;

class RouteError extends Error {
  int _httpStatus;
  String _httpMessage;

  RouteError(this._httpStatus, this._httpMessage);

  int getStatus() => this._httpStatus;
  String getMessage() => this._httpMessage;
}
