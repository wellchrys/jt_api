defmodule Just.Utils.Split do
  @moduledoc """
    Expose utils functionalities to handle with string split
  """

  @spec split_array_to_string([String.t()] | nil) :: String.t()
  def split_array_to_string(array) do
    case array do
      nil ->
        nil

      "" ->
        nil

      _ ->
        Enum.join(array, ", ")
    end
  end
end
