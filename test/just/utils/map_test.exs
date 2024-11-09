defmodule Just.Utils.MapTest do
  @moduledoc false

  use ExUnit.Case, async: true

  describe "convert_keys_to_atoms/1" do
    test "param is map w/ string keys" do
      assert Just.Utils.Map.convert_keys_to_atoms(%{"foo" => "bar"}) == %{foo: "bar"}
    end

    test "param is map w/ string keys and nested items" do
      assert Just.Utils.Map.convert_keys_to_atoms(%{
               "foo" => %{"foo" => "bar"},
               "bar" => [1],
               "foo_bar" => [%{"foo" => "bar"}]
             }) == %{foo: %{foo: "bar"}, bar: [1], foo_bar: [%{foo: "bar"}]}
    end

    test "param is map w/ atom keys" do
      assert Just.Utils.Map.convert_keys_to_atoms(%{foo: "bar"}) == %{foo: "bar"}
    end

    test "param is list" do
      param = [Faker.Lorem.word(), Faker.random_between(1, 999)]
      assert Just.Utils.Map.convert_keys_to_atoms(param) == param
    end

    test "param is of map" do
      assert Just.Utils.Map.convert_keys_to_atoms([%{"key" => "value", foo: "bar"}]) == [
               %{key: "value", foo: "bar"}
             ]
    end

    test "param is string" do
      param = Faker.Lorem.word()
      assert Just.Utils.Map.convert_keys_to_atoms(param) == param
    end

    test "param is atom" do
      param = :foo
      assert Just.Utils.Map.convert_keys_to_atoms(param) == param
    end

    test "param is numeric" do
      param = Faker.random_between(1, 999)
      assert Just.Utils.Map.convert_keys_to_atoms(param) == param
    end
  end
end
