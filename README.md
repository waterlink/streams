# streams

Playing around with capabilities for concurrent functional processing.

PoC state.

## Installation

```yaml
dependencies:
  streams:
    github: waterlink/streams
```

## Usage

```crystal
require "streams"
```

### Short example

```crystal
fut = source("Hello world".each_char)
  .map(f Char[__.upcase])
  .select(f Char[77 < __.ord])
  .run_with(Sink.each f Char[print __])
# => Streams::Future<...>
```

Eventually it will output `OWOR`.

## Contributing

1. Fork it ( https://github.com/waterlink/streams/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [waterlink](https://github.com/waterlink) Oleksii Fedorov - creator, maintainer
