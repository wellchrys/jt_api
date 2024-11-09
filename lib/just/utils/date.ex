defmodule Just.Utils.Date do
  @moduledoc """
    Expose utils functionalities to handle with date conversion
  """

  @spec convert_string_date_time_to_date!(String.t()) :: Date.t()
  def convert_string_date_time_to_date!(date_time) do
    case date_time do
      nil ->
        nil

      "" ->
        nil

      _ ->
        [date, _hour] = String.split(date_time, "T")
        Date.from_iso8601!(date)
    end
  end

  @spec convert_string_to_date_time!(String.t()) :: DateTime.t()
  def convert_string_to_date_time!(date_time) do
    case date_time do
      nil ->
        nil

      "" ->
        nil

      _ ->
        {:ok, actual_date_time, _} = DateTime.from_iso8601(date_time)

        actual_date_time
    end
  end

  @spec convert_date_string_to_date_time!(String.t()) :: DateTime.t()
  def convert_date_string_to_date_time!(date) do
    case date do
      nil ->
        nil

      "" ->
        nil

      _ ->
        {:ok, actual_date_time, _} = DateTime.from_iso8601("#{date}T00:00:00-03:00")

        actual_date_time
    end
  end
end
