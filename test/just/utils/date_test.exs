defmodule Just.Utils.DateTest do
  @moduledoc false

  use ExUnit.Case, async: true

  describe "convert_string_date_time_to_date!/1" do
    test "return converted date from string date time" do
      {:ok, expected_date} = Date.from_iso8601("2022-01-01")
      actual_date = Just.Utils.Date.convert_string_date_time_to_date!("2022-01-01T00:00:00")

      assert expected_date == actual_date
    end

    test "return nil when date param has a null value" do
      assert nil == Just.Utils.Date.convert_string_date_time_to_date!(nil)
    end

    test "return nil when date param has an empty value" do
      assert nil == Just.Utils.Date.convert_string_date_time_to_date!("")
    end
  end

  describe "convert_string_to_date_time!/1" do
    test "return converted date time from string date time" do
      {:ok, expected_date, _} = DateTime.from_iso8601("2022-01-01T00:00:00-03:00")
      actual_date = Just.Utils.Date.convert_string_to_date_time!("2022-01-01T00:00:00-03:00")

      assert expected_date == actual_date
    end

    test "return nil when date time param has a null value" do
      assert nil == Just.Utils.Date.convert_string_to_date_time!(nil)
    end

    test "return nil when date time param has an empty value" do
      assert nil == Just.Utils.Date.convert_string_to_date_time!("")
    end
  end
end
