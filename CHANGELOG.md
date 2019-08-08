## 4.2.0
- add generics

## 4.1.0
- add StatusOnlyResponse
- update syntax

## 4.0.2+1
- Stronger Type

## 4.0.2
- Bugifx: Multiple starts doesn't end in error

## 4.0.1
- Prepare for upcoming change to `HttpRequest` and `HttpClientResponse`

## 4.0.0 (2019-07-01)
- add tests
- rename classes
- RestApiController set CORS-header as default

## 3.1.6+5 (2019-06-26)
- add .editorconfig and change homepage url to https

## 3.1.6+4 (2019-06-26)
- add pedantic dev_dependency, dartfmt, dartanalyzer

## 3.1.6+3 (2019-06-25)
- more clean up to increase pub scoring

## 3.1.6+2 (2019-06-25)
- clean up with dartanalyzer

## 3.1.6+1 (2019-06-25)
- Prepare for upcoming change to File.openRead()

## 3.1.6 (2019-01-13)
- add analysis_options

## 3.1.5 (2019-01-13)
- change description in pubspec

## 3.1.4 (2019-01-13)
- bugfix

## 3.1.3 (2019-01-13)
- add example
- change description in pubspec

## 3.1.2 (2019-01-13)
- reformat the code

## 3.1.1 (2019-01-13)
- bugfixing

## 3.1.0 (2019-01-13)
- add FolderResponse Class

## 3.0.0 (2019-01-09)
- static content is now handled on anonther way

## 2.0.5 (2019-01-06)
- dependency update: increase mime_type to version ^0.2.2

## 2.0.4 (2019-01-06)
- if auth if null, we send an 401 instead of 403 now

## 2.0.3 (2019-01-05)
- bugfixing

## 2.0.2 (2019-01-05)
- bugfixing

## 2.0.1 (2019-01-05)
- bugfixing

## 2.0.0 (2019-01-05)
- change to dart 2.1.0

## 1.0.1 (2018-01-14)
- remove basepath handling while static-content detection

## 1.0.0 (2018-01-14)
- add RedirectResponse to make simple redirects
- dependency upgrade: increase mime_type to version 0.2.1
- add enviroment sdk constraint to dart ">=1.8.0 <2.0.0"

## 0.3.6 (2016-05-13)
- add WebSocketController for handle websockets

## 0.3.5 (2016-05-13)
- add NoneResponse responsehandler

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
