defmodule JustWeb.GraphQL.Middlewares.HandleErrors do
  @moduledoc false

  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    %{resolution | errors: Enum.flat_map(resolution.errors, &handle_error/1)}
  end

  defp handle_error(%Ecto.Changeset{errors: errors}) when length(errors) > 0 do
    Enum.map(errors, fn error ->
      {field, {first_elem, second_elem}} = error

      if is_atom(first_elem) do
        [{message, _}] = second_elem
        Atom.to_string(first_elem) <> " " <> message
      else
        Atom.to_string(field) <> " " <> first_elem
      end
    end)
  end

  defp handle_error(%Ecto.Changeset{changes: changes}) do
    changes
    |> Enum.filter(fn {_k, v} ->
      case v do
        %Ecto.Changeset{} -> true
        _ -> false
      end
    end)
    |> Keyword.values()
    |> Enum.map(&handle_error/1)
    |> Enum.flat_map(& &1)
  end

  defp handle_error(error) do
    if Exception.exception?(error) do
      [Exception.message(error)]
    else
      [error]
    end
  end
end
