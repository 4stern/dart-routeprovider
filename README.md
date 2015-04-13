# dart-routeprovider

## Installation

Install the package
```
$ pub get route_provider
```

add it to your dependencies
```
dependencies:
  route_provider: any
```
## Usage
```javascript
import 'dart:io';
main() {
    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4,8080).then((HttpServer server){
        new RouteProvider(server, {
            "defaultRoute":"/",
            "staticContentRoot":"/docroot/assets"
        })
        ..route({
            "url": "/",
            "controller": new ControllerEmpty(),
            "response": new FileResponse("docroot/index.html")
        })
        ..route({
            "url": "/impress",
            "controller": new ControllerEmpty(),
            "response": new FileResponse("docroot/impress.html")
        })
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
