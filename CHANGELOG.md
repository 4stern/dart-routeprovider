## 0.2.0 (2015-08-??)
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
