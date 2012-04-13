JSON Protocol for Elixir
========================

This is an initial work on a [JSON](http://www.ietf.org/rfc/rfc4627.txt) [Protocol](http://elixir-lang.org/getting_started/4.html) in
[Elixir](http://elixir-lang.org). It is a WIP and only generate JSON from a list of tuples. It doesn't parses JSON yet.

## Examples

```elixir
 JSON.generate([ key: "some value" ])
 #=> "{\"key\":\"some value\"}"

 JSON.generate([ k: [ 1, 2, 3 ] ])
 #=> "{\"k\":[1,2,3]}"

 JSON.generate([ k1: [ k2: [ k3: "v3" ] ] ])
 #=> "{\"k1\":{\"k2\":{\"k3\":\"v3\"}}}"

 JSON.generate([
    image: [
      width: 800,
      height: 600,
      title: "View from 15th Floor",
      thumbnail: [
        url: "http://www.example.com/image/481989943",
        height: 125,
        width: 100
      ],
      ids: [ 116, 943, 234, 38793 ]
    ]
 ])
 #=> "{\"image\":{\"height\":600,\"ids\":[116,943,234,38793],\"thumbnail\":{\"height\":125,\"url\":\"http://www.example.com/image/481989943\",\"width\":100},\"title\":\"View from 15th Floor\",\"width\":800}}"

```

## License

Copyright 2012 Dickson S. Guedes.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
