defmodule Just.FiltersTest do
  use Just.DataCase

  import Ecto.Query, only: [from: 1]

  alias Just.Filters
  alias Just.Tickets.Ticket

  describe "apply_filters/3" do
    for op <- [:eq, :lt, :gt, :lte, :gte, :ie] do
      test "properly return the Ecto queryable to the right operator clause #{op}" do
        filter = %{ticket_value: "0.12"}

        %Ecto.Query.BooleanExpr{expr: expr, params: params} =
          Ticket
          |> from()
          |> Filters.apply_filters(unquote(op), filter)
          |> (& &1.wheres).()
          |> (&hd(&1)).()

        assert Macro.to_string(expr) == "true and &0.ticket_value() #{operator(unquote(op))} ^0"

        assert Macro.to_string(params) == "[{\"0.12\", {0, :ticket_value}}]"
      end
    end

    test "properly return the Ecto queryable to the right operator clause like" do
      filter = %{ticket_value: "0.12"}

      %Ecto.Query.BooleanExpr{expr: expr, params: params} =
        Ticket
        |> from()
        |> Filters.apply_filters(filter)
        |> (& &1.wheres).()
        |> (&hd(&1)).()

      assert Macro.to_string(expr) ==
               "true and ilike(type(&0.ticket_value(), :string), ^0)"

      assert Macro.to_string(params) == "[{\"%0.12%\", :string}]"
    end
  end

  defp operator(:eq = _), do: "=="

  defp operator(:lt = _), do: "<"

  defp operator(:gt = _), do: ">"

  defp operator(:lte = _), do: "<="

  defp operator(:gte = _), do: ">="

  defp operator(:ie = _), do: "!="
end
