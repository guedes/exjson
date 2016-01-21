defmodule ExJSON.Mixfile do
  use Mix.Project

  def project do
    [ app: :exjson,
      version: "0.4.0",
      elixir: "~> 1.1.0",
      description: description,
      package: package,
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    []
  end

  defp description do
    """
    A simple Elixir implementation of JSON with an Erlang parser.
    """
  end

  defp package do
    [ 
      files: ["lib", "mix.exs", "src", "README*", "readme*"],
      contributors: ["Dickson S. Guedes"],
      licenses: ["Apache 2.0"],
      links: [ { "Github", "https://github.com/guedes/exjson" } ]
    ]
  end

end
