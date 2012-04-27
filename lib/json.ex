defmodule JSON do
  def generate(thing), do: JSON.Generator.generate(thing)
  def parse(thing), do: JSON.Parser.parse(thing)
end

