# dart-routeprovider

## Installation

Add it to your dependencies
```
dependencies:
  route_provider: ^4.2.1
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
    Auth freeForAll = StaticAuth(authed: true);
    Auth userAuth = MyAuth();
    Responser jsonResponser = JsonResponse();
    HttpServer.bind(InternetAddress.anyIPv4,8080).then((HttpServer server){
        Router(server)
        ..route(
            url: "/",
            responser: FileResponse("docroot/index.html"),
            auth: freeForAll
        )
        ..route(
            url: '/assets/**',
            responser: FolderResponse("docroot/assets/"),
            auth: freeForAll
        )
        ..route(
            url: "/impress",
            responser: FileResponse("docroot/impress.html"),
            auth: freeForAll
        )
        ..route(
            url: "/api/data/:id",
            controller: DataRestApiController(),
            responser: jsonResponser,
            auth: userAuth
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
5. Submit a pull request

## Credits

Robert Beyer <4sternrb@googlemail.com>

## License

MIT
