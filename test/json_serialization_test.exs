Code.require_file "../test_helper", __FILE__

defmodule JSONSerialization.TupleTest do
  use ExUnit.Case

  test :simple_tuple_to_json do
    assert_equal "{ 'k': 'v' }", JSONSerialization.to_json({ :k, "v" })
    assert_equal "{ 'another_key': 'some value with space' }", JSONSerialization.to_json({ :another_key, "some value with space" })
  end

  test :nested_tuple_to_json do
    assert_equal "{ 'k1': { 'k2': 'v2' } }", JSONSerialization.to_json({ :k1, { :k2, "v2" } })
    assert_equal "{ 'k1': { 'k2': { 'k3': 'v3' } } }", JSONSerialization.to_json( { :k1, { :k2, { :k3, "v3" } } } )
  end

end
