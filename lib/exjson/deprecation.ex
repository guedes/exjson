defmodule ExJSON.Deprecation do
  defmacro handle(fun, arg) do
    quote do
      IO.puts "** WARNING! ** The `JSON` module's name was deprecated due to conflict with others apps that use the same namespace, and will be removed in future versions, please use `ExJSON` instead."
      ExJSON.unquote(fun)(unquote(arg))
    end
  end
end
