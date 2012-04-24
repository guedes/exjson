defmodule JSON.Scanner do

  def json_object("{}"), do: []

  def json_object(object) do
    regex = %r/\{(.+)\}/

    destructure([_, members ], Regex.run(regex, object))
    [ json_pair(members) ]
  end

  def json_pair(pair) do
    regex = %r/^"(.+)":(.+)$/
    destructure([ _, key, value ], Regex.run(regex, pair))
    { json_string(key, :as_key), json_value(value) }
  end

  def json_string(string, :as_key), do: binary_to_atom(string)
  def json_string(string), do: string

  def json_value("[]"), do: []

  def json_value("\"" <> value) do
    regex = %r/^(.+)"$/
    destructure([ _, string ], Regex.run(regex, value))
    string
  end

  def json_value("[" <> value) do
    regex = %r/^(.+)]$/
    destructure([ _, array ], Regex.run(regex, value))
    json_array(array)
  end

  def json_array(array) do
    result = Regex.split %r/,/, array

    if Regex.match?(%r/^(\d,?)+$/, array) do
      Enum.map(result, fn(x) -> list_to_integer(binary_to_list(x)) end)
    end
  end
end
