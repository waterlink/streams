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
include Streams
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

### Folding in `run_with`

```crystal
source("Hello world".each_char)
  .map(f Char[__.upcase])
  .select(f Char[77 < __.ord])
  .map(f Char[__.ord])
  .run_with(Sink.fold f2 [Int32, Int32][_1 + _2])
  .map(f Int32[puts(__)])
```

Eventually it will output `327`.

### One argument function syntax

Function with one argument of type T: `f T[...]`, where `...` - is the body of
the function.

Body of the function can reference "placeholder" `__` which will be equal to
function argument, when it will be called.

Example:

```crystal
x = f Int32[__ * 3 + 1]
x.call(7)   # => 22
```

### Two argument function syntax

Function with two arguments of types T1, T2: `f2 [T1, T2][...]`, where `...` -
is the body of the function.

Body of the function can reference first and second arguments as "placeholder"
`_1` and `_2` respectfully.

Example:

```crystal
x = f2 [Int32, Char][_1 * _2.ord < 1000]
x.call(16, 'a')  # => false
```

## Contributing

1. Fork it ( https://github.com/waterlink/streams/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [waterlink](https://github.com/waterlink) Oleksii Fedorov - creator, maintainer
