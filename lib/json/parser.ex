defmodule JSON.Parser do

  def parse(thing) when is_binary(thing) do
      parse(String.to_char_list!(thing))
  end

  def parse(thing) when is_list(thing) do
      tokens = JSON.Scanner.scan(thing)
      parse(tokens)
  end

  def parse({:ok, list, _}) do
      result = :json_parser.parse(list)
      elem(result, 1)
  end

end
