Code.require_file "../test_helper", __FILE__

defmodule JSON.TupleTest do
  use ExUnit.Case

  test :empty_json do
    assert_equal "{}", JSON.generate([])
    assert_equal "{}", JSON.generate({})
    assert_equal "{}", JSON.generate([{}])
  end

  test :atom_to_quoted do
    assert_equal "\"name\"", JSON.generate(:name)
    assert_equal "\"Name\"", JSON.generate(:Name)
    assert_equal "\"IDs\"", JSON.generate(:"IDs")
  end

  test :string_to_quoted do
    assert_equal "\"name\"", JSON.generate("name")
    assert_equal "\"Name\"", JSON.generate("Name")
    assert_equal "\"IDs\"", JSON.generate("IDs")
  end

  test :number_to_quoted do
    assert_equal "1", JSON.generate(1)
    assert_equal "1.00000000000000000000e+00", JSON.generate(1.0)
    assert_equal "1.23101230000000009568e+03", JSON.generate(1231.0123)
  end

  test :tuple_to_pair do
    assert_equal "\"name\":\"A Cool Name\"", JSON.generate({ :name, "A Cool Name" })
  end

  test :kv_to_json do
    assert_equal "{\"name\":\"A Cool Name\"}", JSON.generate([ name: "A Cool Name" ])
  end

  test :complex_json do
    assert_equal "{\"image\":{\"title\":\"Some View\",\"width\":800}}", JSON.generate([ image: [ width: 800, title: "Some View" ] ])
  end

end
