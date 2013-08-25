Code.require_file "../test_helper.exs", __FILE__

defmodule JSON.TupleTest do
  use ExUnit.Case

  test :empty_json do
    assert "{}" ==  JSON.generate([])
    assert "{}" ==  JSON.generate({})
    assert "{}" ==  JSON.generate([{}])
  end

  test :atom_to_quoted do
    assert "\"name\"" ==  JSON.generate(:name)
    assert "\"Name\"" ==  JSON.generate(:Name)
    assert "\"IDs\"" ==  JSON.generate(:"IDs")
  end

  test :string_to_quoted do
    assert "\"name\"" ==  JSON.generate("name")
    assert "\"Name\"" ==  JSON.generate("Name")
    assert "\"IDs\"" ==  JSON.generate("IDs")
  end

  test :number_to_quoted do
    assert "1" ==  JSON.generate(1)
    assert "1.0" ==  JSON.generate(1.0)
    assert "1231.0123" ==  JSON.generate(1231.0123)
  end

  test :tuple_to_pair do
    assert "\"name\":\"A Cool Name\"", JSON.generate({ :name , "A Cool Name" })
  end

  test :kv_to_json do
    assert "{\"name\":\"A Cool Name\"}" ==  JSON.generate([ name: "A Cool Name" ])
  end

  test :nested_kv_to_json do
    assert "{\"image\":{\"title\":\"Some View\",\"width\":800}}" == JSON.generate([ image: [ title: "Some View", width: 800 ] ])
  end

  test :key_with_number_array_as_value_to_json do
    assert "{\"path\":\"/some/path\",\"tags\":[1,2,3]}" == JSON.generate([ path: "/some/path", tags: [ 1, 2, 3 ] ])
  end

  test :rfc4267_json_object do
    # See http://www.ietf.org/rfc/rfc4627.txt
    assert "{\"image\":{\"height\":600,\"ids\":[116,943,234,38793],\"thumbnail\":{\"height\":125,\"url\":\"http://www.example.com/image/481989943\",\"width\":100},\"title\":\"View from 15th Floor\",\"width\":800}}"  == JSON.generate(
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
