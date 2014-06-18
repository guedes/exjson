defmodule ExJSON.Parser do

  def parse(thing, return_type) when is_binary(thing) do
    parse(String.to_char_list(thing), return_type)
  end

  def parse(thing, return_type) when is_list(thing) do
    tokens = ExJSON.Scanner.scan(thing)
    parse(tokens, return_type)
  end

  def parse({:ok, list, _}, return_type) do
    result = normalize_parser(return_type).parse(list)
    elem(result, 1)
  end

  defp normalize_parser(return_type) when is_atom(return_type) do
    String.to_atom("exjson_" <> Atom.to_string(return_type))
  end
end
