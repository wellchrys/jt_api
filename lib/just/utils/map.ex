defmodule Just.Utils.Map do
  @moduledoc """
    Expose utils functionalities for maps
  """

  @doc ~S"""
    Convert keys in a map or list of maps from String to Atom
  ## Examples
      iex> Just.Utils.convert_keys_to_atoms(%{"foo" => "bar"})
      %{foo: "bar"}

      iex> Just.Utils.convert_keys_to_atoms([%{"foo" => "bar"}])
      [%{foo: "bar"}]
  """
  @spec convert_keys_to_atoms(map() | list() | term()) :: map() | list() | term()
  def convert_keys_to_atoms(string_key_map) when is_map(string_key_map) do
    if Map.has_key?(string_key_map, :__struct__) do
      string_key_map
      |> Map.from_struct()
      |> convert!()
    else
      convert!(string_key_map)
    end
  end

  def convert_keys_to_atoms(string_key_list) when is_list(string_key_list) do
    Enum.map(string_key_list, &convert_keys_to_atoms/1)
  end

  def convert_keys_to_atoms(value), do: value

  @doc ~S"""
  Remove key in a map and replace it with a new key
  ## Examples
      iex> Just.Utils.replace_key(%{foo: "foo"}, :foo, :bar)
      %{bar: "foo"}

      iex> Just.Utils.replace_key(%{}, :foo, :bar)
      %{}
  """
  @spec replace_key(map(), atom(), atom()) :: map()
  def replace_key(map, remove_key, new_key) do
    case Map.has_key?(map, remove_key) do
      false ->
        %{}

      true ->
        map
        |> Map.put(
          new_key,
          Map.get(
            map,
            remove_key
          )
        )
        |> Map.delete(remove_key)
    end
  end

  defp convert!(string_key_map) do
    string_key_map
    |> Enum.map(fn {key, val} ->
      {"#{key}" |> ProperCase.snake_case() |> String.to_atom(), convert_keys_to_atoms(val)}
    end)
    |> Enum.into(%{})
  end
end
