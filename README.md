This provides a Swift client for talking to [Vert.x](http://vertx.io)
via the
[vertx-tcp-eventbus-bridge](https://github.com/vert-x3/vertx-tcp-eventbus-bridge).

It has only been tested with [Swift 3.1](https://swift.org/download/)
on MacOS X and Ubuntu.

## Running the tests

`make test`

The tests build a Vert.x server and launch it, so you'll need Java (8
or higher) and maven installed.

## Generating docs

To generate documentation, you'll need to have
[`sourcekitten`](https://github.com/jpsim/SourceKitten) and
[`jazzy`](https://github.com/realm/jazzy) installed. The easiest way
to do that (on MacOS) is with:

```
brew install sourcekitten
sudo gem install jazzy
```

Then, build the docs with:

`make docs`

The generated docs will be available in `docs/`.

## License

vertx-swift-eventbus is licensed under the Apache License, v2. See
[LICENSE](LICENSE) for details.

