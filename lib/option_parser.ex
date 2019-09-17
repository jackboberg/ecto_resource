defmodule EctoResource.OptionParser do
  @moduledoc false

  alias EctoResource.Helpers

  @functions [
    { "update!", 2 },
    { "update", 2 },
    { "get_by!", 2 },
    { "get_by", 2 },
    { "get!", 2 },
    { "get", 2 },
    { "delete!", 1 },
    { "delete", 1 },
    { "create!", 1 },
    { "create", 1 },
    { "change", 1 },
    { "all", 1 }
  ]

  @spec parse(String.t(), list() | atom()) :: map()

  def parse(suffix, []) do
    @functions
    |> Enum.reduce(%{}, fn {function, arity}, acc ->
      Map.put(acc, String.to_atom(function), %{
        name: function_name(function, suffix),
        description: function_description(function, arity, suffix)
      })
    end)
  end

  def parse(suffix, :read), do: parse(suffix, only: [:all, :get, :get!, :get_by, :get_by!])

  def parse(suffix, :read_write),
    do: parse(suffix, only: [:all, :get, :get!, :get_by, :get_by!, :change, :create, :create!, :update, :update!])

  def parse(suffix, options) do
    @functions
    |> filter_functions(options)
    |> Enum.reduce(%{}, fn {function, arity}, acc ->
      Map.put(acc, String.to_atom(function), %{
        name: function_name(function, suffix),
        description: function_description(function, arity, suffix)
      })
    end)
  end

  @spec create_suffix(module, list()) :: String.t()
  def create_suffix(_, [suffix: false]), do: ""
  def create_suffix(schema, _), do: Helpers.underscore_module_name(schema)

  defp function_name(function, ""), do: String.to_atom(function)
  defp function_name("all", suffix), do: String.to_atom("all_" <> Inflex.pluralize(suffix))

  defp function_name("get_by", suffix) do
    String.to_atom("get_#{suffix}_by")
  end

  defp function_name("get_by!", suffix) do
    String.to_atom("get_#{suffix}_by!")
  end

  defp function_name(function, suffix) do
    case function =~ ~r/!/ do
      true -> String.replace_suffix(function, "!", "") <> "_" <> suffix <> "!"
      false -> function <> "_" <> suffix
    end
    |> String.to_atom
  end

  defp function_description(function, arity, "") do
   function <> "/" <> Integer.to_string(arity)
  end

  defp function_description("all", arity, suffix) do
    "all_" <> Inflex.pluralize(suffix) <> "/" <> Integer.to_string(arity)
  end

  defp function_description("get_by", arity, suffix) do
    arity = Integer.to_string(arity)
   "get_" <> suffix <> "_by" <> "/" <> arity
  end

  defp function_description("get_by!", arity, suffix) do
     arity = Integer.to_string(arity)
    "get_" <> suffix <> "_by!" <> "/" <> arity
  end

  defp function_description(function, arity, suffix) do
    arity = Integer.to_string(arity)
    case function =~ ~r/!/ do
      true -> String.replace_suffix(function, "!", "") <> "_" <> suffix <> "!" <> "/" <> arity
      false -> function <> "_" <> suffix <> "/" <> arity
    end
  end

  defp filter_functions(functions, [except: filters]) do
    Enum.reject(functions, fn {function, _} ->
      function = String.to_atom(function)
      Enum.member?(filters, function)
    end)
  end

  defp filter_functions(functions, [only: filters]) do
    Enum.filter(functions, fn {function, _} ->
      function = String.to_atom(function)
      Enum.member?(filters, function)
    end)
  end

  defp filter_functions(functions, _), do: functions
end
