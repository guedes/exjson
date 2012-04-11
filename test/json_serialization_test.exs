Code.require_file "../test_helper", __FILE__

defmodule JSON.TupleTest do
  use ExUnit.Case

  test :empty_json do
    assert_equal "{}", JSON.generate({})
    assert_equal "{}", JSON.generate([])
    assert_equal "{}", JSON.generate([{}])
  end

  test :simple_tuple_generate do
    assert_equal "{\"k\":\"v\"}", JSON.generate({ :k, "v" })
    assert_equal "{\"another_key\":\"some value with space\"}", JSON.generate({ :another_key, "some value with space" })
  end

  test :nested_tuple_generate do
    assert_equal "{\"k1\":{\"k2\":\"v2\"}}", JSON.generate({ :k1, { :k2, "v2" } })
    assert_equal "{\"k1\":{\"k2\":{\"k3\":\"v3\"}}}", JSON.generate( { :k1, { :k2, { :k3, "v3" } } } )
  end

  #  test :a_tuple_with_list_generate do
  #    assert_equal "{ 'k': [ 1, 2, 3 ] }", JSON.generate({ :k, [ 1, 2, 3 ] })
  #  end

  test :simple_list_generate do
    assert_equal "{\"k2\":\"value 2\"}", JSON.generate( [ { :k2, "value 2" } ] )
  end

end
