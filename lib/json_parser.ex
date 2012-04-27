defmodule JSON.Parser do

  def parse(thing) when is_binary(thing) do
    parse(binary_to_list(thing))
  end

  def parse(thing) when is_list(thing) do
    tokens = JSON.Scanner.scan(thing)
    parse(tokens)
  end

  def parse({:ok, list, _}) do
    Erlang.json_parser.parse(list)[2]
  end
end
