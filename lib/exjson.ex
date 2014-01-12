defmodule ExJSON do
  @moduledoc """
  This module is responsible to generate and parse JSON.
  """

  @doc """
  Creates a JSON document from a Elixir data structure.

  ## Examples

      json = ExJSON.generate([ {"hello", "world"}, { "its", ["is", "very", "nice" ]}])
      #=> "{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}"
  """
  def generate(thing), do: ExJSON.Generator.generate(thing)
  
  @doc """
  Creates a Elixir data structure from a JSON document.

  ## Examples

      json = json = ExJSON.parse("{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}")
      #=> [{"hello","world"},{"its",["is","very","nice"]}]
  """
  def parse(thing), do: ExJSON.Parser.parse(thing)
end

