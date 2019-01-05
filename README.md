# dart-routeprovider

[![Join the chat at https://gitter.im/4stern/dart-routeprovider](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/4stern/dart-routeprovider?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Build Status](https://drone.io/github.com/4stern/dart-routeprovider/status.png)](https://drone.io/github.com/4stern/dart-routeprovider/latest) [![Stories in Ready](https://badge.waffle.io/4stern/dart-routeprovider.png?label=ready&title=Ready)](https://waffle.io/4stern/dart-routeprovider)

## Installation

Add it to your dependencies
```
dependencies:
  route_provider: any
```

and install the package
```
$ pub get
```

## Usage
```javascript
import 'dart:io';
import 'package:route_provider/route_provider.dart';
main() {
    HttpServer.bind(InternetAddress.loopbackIPv4,8080).then((HttpServer server){
        new RouteProvider(server, {
            "defaultRoute":"/",
            "staticContentRoot":"/docroot"
        })
        ..route(
            url: "/",
            controller: new EmptyRouteController(),
            responser: new FileResponse("docroot/index.html"),
            auth: new StaticAuth(authed: true)
        )
        ..route(
            url: "/impress",
            controller: new RestApiController(),
            responser: new FileResponse("docroot/impress.html"),
            auth: new StaticAuth(authed: true)
        )
        ..start();
    }).catchError((e) => print(e.toString()));
}
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Credits

Robert Beyer <4sternrb@googlemail.com>

## License

MIT
