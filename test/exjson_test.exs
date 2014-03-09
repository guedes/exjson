defmodule ExJSON.TupleTest do
  use ExUnit.Case

  test :empty_json do
    assert "{}" ==  ExJSON.generate([])
    assert "{}" ==  ExJSON.generate({})
    assert "[]" ==  ExJSON.generate([{}])
  end

  test :nil do
    assert "null" ==  ExJSON.generate(nil)
  end

  test :true do
    assert "true" ==  ExJSON.generate(true)
  end

  test :false do
    assert "false" ==  ExJSON.generate(false)
  end

  test :atom_to_quoted do
    assert "\"name\"" ==  ExJSON.generate(:name)
    assert "\"Name\"" ==  ExJSON.generate(:Name)
    assert "\"IDs\"" ==  ExJSON.generate(:"IDs")
  end

  test :string_to_quoted do
    assert "\"name\"" ==  ExJSON.generate("name")
    assert "\"Name\"" ==  ExJSON.generate("Name")
    assert "\"IDs\"" ==  ExJSON.generate("IDs")
  end

  test :number_to_quoted do
    assert "1" ==  ExJSON.generate(1)
    assert "1.0" ==  ExJSON.generate(1.0)
    assert "1231.0123" ==  ExJSON.generate(1231.0123)
  end

  test :float_array_test do
    assert [ { "another_key", [ 1.0, 0.2, 3.3 ] } ] == ExJSON.parse('{ "another_key": [ 1.0, 0.2, 3.3 ] }')
  end

  test :brackets_inside_string do
    assert [ {"output_wrap_begin" , "[[" }, { "output_wrap_end", "]]" } ] == ExJSON.parse('{"output_wrap_begin":"[[","output_wrap_end":"]]"}')
  end

  test :tuple_to_pair do
    assert "\"name\":\"A Cool Name\"", ExJSON.generate({ :name , "A Cool Name" })
  end

  test :kv_to_json do
    assert "{\"name\":\"A Cool Name\"}" ==  ExJSON.generate([ name: "A Cool Name" ])
  end

  test :nested_kv_to_json do
    assert "{\"image\":{\"title\":\"Some View\",\"width\":800}}" == ExJSON.generate([ image: [ title: "Some View", width: 800 ] ])
  end

  test :key_with_number_array_as_value_to_json do
    assert "{\"path\":\"/some/path\",\"tags\":[1,2,3]}" == ExJSON.generate([ path: "/some/path", tags: [ 1, 2, 3 ] ])
  end

  test :json_string_with_unicode do
    assert "{\"email\":\"cc@example.com\",\"password\":\"abc\",\"_utf8\":\"☃\"}" == ExJSON.generate([ email: "cc@example.com", password: "abc", _utf8: "☃" ])
    assert [ { "email", "cc@example.com" }, { "password", "abc"}, { "_utf8", "☃" } ] == ExJSON.parse("{\"email\":\"cc@example.com\", \"password\": \"abc\",\"_utf8\":\"☃\"}") 
  end

  test :rfc4267_json_object do
    # See http://www.ietf.org/rfc/rfc4627.txt
    assert "{\"image\":{\"height\":600,\"ids\":[116,943,234,38793],\"thumbnail\":{\"height\":125,\"url\":\"http://www.example.com/image/481989943\",\"width\":100},\"title\":\"View from 15th Floor\",\"width\":800}}"  == ExJSON.generate(
      [ image: [
          height: 600,
          ids: [ 116, 943, 234, 38793 ],
          thumbnail: [
            height: 125,
            url: "http://www.example.com/image/481989943",
            width: 100
          ],
          title: "View from 15th Floor",
          width: 800
        ]
      ])
  end
end
