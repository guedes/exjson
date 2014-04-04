defmodule ExJSON.Map do

  def to_map(thing) when is_binary(thing) do
    to_map(String.to_char_list!(thing))
  end

  def to_map(thing) when is_list(thing) do
    tokens = ExJSON.Scanner.scan(thing)
    to_map(tokens)
  end

  def to_map({ :ok, list, _ }) do
    result = :json_tomap.parse(list)
    elem(result, 1)
  end
end
