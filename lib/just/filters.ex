defmodule Just.Filters do
  @moduledoc """
    Expose query filters
  """
  import Ecto.Query, only: [where: 2, dynamic: 1, dynamic: 2, or_where: 3]

  @type operator_type :: :eq | :lt | :gt | :lte | :gte | :ie | :lk | :or

  @spec handle_filter_options([atom()], map()) :: map()
  def handle_filter_options(filter_options, filters) do
    filter_options
    |> Enum.map(fn filter_option ->
      Map.put(%{}, filter_option, Map.get(filters, filter_option))
    end)
    |> Enum.reduce(&Map.merge/2)
    |> Enum.filter(fn {_k, v} -> v != nil end)
    |> Enum.into(%{})
  end

  @spec convert_map_to_list_and_replace_keys_for_or_condition(map(), atom()) :: keyword()
  def convert_map_to_list_and_replace_keys_for_or_condition(map, new_key) do
    map
    |> Map.get_lazy(new_key, fn -> %{} end)
    |> Map.to_list()
    |> Enum.reduce([], fn {_old_key, val}, acc ->
      acc ++ [{new_key, val}]
    end)
  end

  @spec apply_filters(Ecto.Queryable.t(), operator_type(), map() | keyword()) ::
          Ecto.Queryable.t()
  def apply_filters(queryable, operator \\ :lk, binding),
    do: handle_where(queryable, operator, binding)

  defp handle_where(queryable, operator, binding) when operator == :or do
    if Enum.empty?(binding),
      do: queryable,
      else:
        Enum.reduce(binding, queryable, fn {key, value}, acc ->
          or_where(acc, [p], field(p, ^key) == ^value)
        end)
  end

  defp handle_where(queryable, operator, binding) do
    where(queryable, ^filter_where(binding, operator))
  end

  defp filter_where(binding, operator) do
    if Enum.empty?(binding),
      do: [],
      else:
        Enum.reduce(binding, dynamic(true), fn {key, value}, dynamic ->
          dynamic_operator(operator, dynamic, key, value)
        end)
  end

  defp dynamic_operator(:lk = _, dynamic, key, value) do
    like = "%#{value}%"

    dynamic([..., p], ^dynamic and p |> field(^key) |> type(:string) |> ilike(^like))
  end

  defp dynamic_operator(:eq = _, dynamic, key, value),
    do: dynamic([..., p], ^dynamic and field(p, ^key) == ^value)

  defp dynamic_operator(:lt = _, dynamic, key, value),
    do: dynamic([..., p], ^dynamic and field(p, ^key) < ^value)

  defp dynamic_operator(:gt = _, dynamic, key, value),
    do: dynamic([..., p], ^dynamic and field(p, ^key) > ^value)

  defp dynamic_operator(:lte = _, dynamic, key, value),
    do: dynamic([..., p], ^dynamic and field(p, ^key) <= ^value)

  defp dynamic_operator(:gte = _, dynamic, key, value),
    do: dynamic([..., p], ^dynamic and field(p, ^key) >= ^value)

  defp dynamic_operator(:ie = _, dynamic, key, value),
    do: dynamic([..., p], ^dynamic and field(p, ^key) != ^value)
end
