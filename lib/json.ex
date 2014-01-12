defmodule JSON do
  @moduledoc """
  This module was DEPRECATED, use `ExJSON` instead
  """

  require ExJSON.Deprecation


  @doc """
  DEPRECATED! Use `ExJSON.generate/1` instead.
  """
  def generate(thing) do
    ExJSON.Deprecation.handle(:generate, thing)
  end

  @doc """
  DEPRECATED! Use `ExJSON.parse/1` instead.
  """
  def parse(thing) do
    ExJSON.Deprecation.handle(:parse, thing)
  end
end

