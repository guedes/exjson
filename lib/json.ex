defmodule JSON do
  @moduledoc """
  This module creates two short-cut function to Generator and Parser.
  """

  @doc """
  Creates a JSON document from a Elixir data structure.

  ## Examples

      json = JSON.generate([ {"hello", "world"}, { "its", ["is", "very", "nice" ]}])
      #=> "{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}"
  """
  def generate(thing), do: JSON.Generator.generate(thing)

  @doc """
  Creates a Elixir data structure from a JSON document.

  ## Examples

      json = json = JSON.parse("{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}")
      #=> [{"hello","world"},{"its",["is","very","nice"]}]
  """
  def parse(thing), do: JSON.Parser.parse(thing)
end

