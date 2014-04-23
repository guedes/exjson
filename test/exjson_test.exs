defmodule ExJSON.TupleTest do
  use ExUnit.Case

  @empties [ [], {}, [{}], %{} ]
  @singles [
    [ :name     , "\"name\""  ],
    [ :Name     , "\"Name\""  ],
    [ :"IDs"    , "\"IDs\""   ],
    [ "name"    , "\"name\""  ],
    [ "Name"    , "\"Name\""  ],
    [ "IDs"     , "\"IDs\""   ],
    [ 1         , "1"         ],
    [ 1.0       , "1.0"       ],
    [ 1231.0123 , "1231.0123" ],
  ]

  test :empty_json do
    @empties |> Enum.each fn value ->
      assert ExJSON.generate(value) == "{}"
    end
  end

  test :singles do
    @singles |> Enum.each fn [ value, expected ] ->
      assert ExJSON.generate(value) == expected
    end
  end

  test :keyword_to_json do
    assert ExJSON.generate([ name: "A Cool Name" ]) == "{\"name\":\"A Cool Name\"}"
  end

  test :map_to_json do
    assert ExJSON.generate(%{ :name => "A Cool Name" }) == "{\"name\":\"A Cool Name\"}"
    assert ExJSON.generate(%{ "name" => "A Cool Name" }) == "{\"name\":\"A Cool Name\"}"
  end

  test :nested_to_json do
    value = "{\"image\":{\"title\":\"Some View\",\"width\":800}}"

    assert ExJSON.generate([ image: [ title: "Some View", width: 800 ] ]) == value
    assert ExJSON.generate(%{ :image => %{ :title => "Some View", :width => 800 } }) == value
  end

  test :key_with_number_array_as_value_to_json do
    value = "{\"path\":\"/some/path\",\"tags\":[1,2,3]}"

    assert ExJSON.generate([ path: "/some/path", tags: [ 1, 2, 3 ] ]) == value
    assert ExJSON.generate(%{ :path => "/some/path", :tags => [ 1, 2, 3 ] }) == value
  end

  test :json_string_with_unicode do
    value = "{\"_utf8\":\"☃\",\"email\":\"cc@example.com\",\"password\":\"abc\"}"

    assert ExJSON.generate([ _utf8: "☃", email: "cc@example.com", password: "abc"]) == value
    assert ExJSON.generate(%{ email: "cc@example.com", password: "abc", _utf8: "☃" }) == value

    assert ExJSON.parse(value) == [ { "_utf8", "☃" }, { "email", "cc@example.com" }, { "password", "abc"} ]
    assert ExJSON.parse_to_map(value) == %{ "_utf8" => "☃" , "email" => "cc@example.com", "password" => "abc" }
  end

  test :rfc4267_json_object do
    # See http://www.ietf.org/rfc/rfc4627.txt
    expected = "{\"image\":{\"height\":600,\"ids\":[116,943,234,38793,1.0,-1.9],\"thumbnail\":{\"height\":125,\"url\":\"http://www.example.com/image/481989943\",\"width\":100},\"title\":\"View from 15th Floor\",\"width\":800}}"
    assert ExJSON.generate([
      image: [
          height: 600,
          ids: [ 116, 943, 234, 38793, 1.0, -1.9 ],
          thumbnail: [
            height: 125,
            url: "http://www.example.com/image/481989943",
            width: 100
          ],
          title: "View from 15th Floor",
          width: 800
        ]
    ]) == expected

    assert ExJSON.generate(%{
      image: %{
          height: 600,
          ids: [ 116, 943, 234, 38793, 1.0, -1.9 ],
          thumbnail: %{
            height: 125,
            url: "http://www.example.com/image/481989943",
            width: 100
          },
          title: "View from 15th Floor",
          width: 800
        }
    }) == expected
  end
end
