defmodule Just.Utils.SplitTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Just.Utils.Split

  describe "split_array_to_string/1" do
    test "should successfully split an array to string" do
      array = ["one", "two", "three"]

      string = Split.split_array_to_string(array)

      assert string == "one, two, three"
    end
  end
end
