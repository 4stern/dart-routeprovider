## 0.3.4 (2015-10-21)
- add AuthResponse to ApiRestController

## 0.3.3 (2015-10-16)
- change auth signature and handling

## 0.3.2 (2015-10-16)
- update tests

## 0.3.1 (2015-10-16)
- parsing http-request and params to auth handler

## 0.3.0 (2015-10-16)
- add the optional named parameter 'auth' (interface Auth) to the route method for authentication possibilities. it checks before the controller and responsehandler do there work if the call is authenticated - default is true.

## 0.2.0 (2015-08-27)
- rename RouteControllerEmpty to EmptyRouteController
- add JsonResponser
- add ApiRestController
- change method signature of .route by using named parameters instead of map

## 0.1.13
- Adding helfer functions to route-controller for parsing body-data like post-values

## 0.1.9 (2015-05-03)
Feature:
- add RouteError for transporting http-status-codes and messages to this layer; to handle error output not for your own

## 0.1.7 (2015-05-03)
Feature:
- add async/await handling

## 0.1.6 (2015-04-24)
Feature:
- RouteControllers execute-methode gets the request as parameter

Test:
- add await expressions and async methods

## 0.1.5 (2015-04-23)
Feature:
 - FileResponseHandler now sends file content as stream to response (@4stern)

## 0.1.4 (2015-04-23)
Tests:
 - adding testfile to test the provider (@4stern)

Bugfixes:
 - fix content root bug (@4stern)
