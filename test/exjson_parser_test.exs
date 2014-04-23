defmodule ExJSON.Parser.ParseTest do
  use ExUnit.Case

  test :simple_tuple do
    assert ExJSON.Parser.parse("{\"key\":\"some value\"}", :to_keyword) == [ { "key", "some value" } ]
    assert ExJSON.Parser.parse("{\"key\":\"some value\"}", :to_map)     == %{ "key" => "some value" }
  end

  test :brackets_inside_string do
    assert ExJSON.Parser.parse('{"output_wrap_begin":"[[","output_wrap_end":"]]"}', :to_keyword) == [ {"output_wrap_begin" , "[[" }, { "output_wrap_end", "]]" } ]
    assert ExJSON.Parser.parse('{"output_wrap_begin":"[[","output_wrap_end":"]]"}', :to_map) == %{"output_wrap_begin" => "[[",  "output_wrap_end" => "]]" }
  end

end

