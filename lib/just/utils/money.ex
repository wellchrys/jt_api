defmodule Just.Utils.Money do
  @moduledoc false

  @spec string_value_to_integer_exp!(String.t()) :: integer()
  def string_value_to_integer_exp!(value) do
    {_, integer_exp, _, _} =
      "#{value}"
      |> Money.parse()
      |> Money.to_integer_exp()

    integer_exp
  end
end
