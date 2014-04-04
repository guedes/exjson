defmodule ExJSON do
  @moduledoc """
  This module is responsible to generate and parse JSON.
  """

  @doc """
  Creates a JSON document from a Elixir data structure.

  ## Examples

      iex> json = ExJSON.generate([ {"hello", "world"}, { "its", ["is", "very", "nice" ]}])
      #=> "{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}"
  """
  def generate(thing), do: ExJSON.Generator.generate(thing)
  
  @doc """
  Creates a Elixir data structure from a JSON document.

  ## Examples

      iex> json = ExJSON.parse("{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}")
      #=> [{"hello","world"},{"its",["is","very","nice"]}]
  """
  def parse(thing), do: ExJSON.Parser.parse(thing)

  @doc """
  Creates a Elixir Map from a JSON document.

  ## Examples

      iex> json = ExJSON.to_map("{\"hello\":\"world\",\"its\":[\"is\",\"very\",\"nice\"]}")
      #=> %{{"hello" => "world"}, {"its" => [ "is", "very", "nice" ] } }
  """
  def to_map(thing), do: ExJSON.Map.to_map(thing)

end

