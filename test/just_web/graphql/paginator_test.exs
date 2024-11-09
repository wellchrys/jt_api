defmodule JustWeb.GraphQL.PaginatorTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias JustWeb.GraphQL.Paginator

  describe "transform_args!/1" do
    test "should return default values when args is a empty map" do
      assert Paginator.transform_args!(%{}) == %{
               after_cursor: nil,
               before_cursor: nil,
               page_size: 10,
               maximum_limit: 100,
               filters: %{}
             }
    end

    test "should set page size max to 100" do
      assert Paginator.transform_args!(%{page_size: 10_001, maximum_limit: 10_001}) == %{
               after_cursor: nil,
               before_cursor: nil,
               page_size: 10_000,
               maximum_limit: 10_000,
               filters: %{}
             }
    end

    test "should use passed values" do
      attrs = %{
        after: Faker.UUID.v4(),
        before: Faker.UUID.v4(),
        page_size: Faker.random_between(1, 100),
        maximum_limit: Faker.random_between(1, 100),
        filters: %{}
      }

      assert Paginator.transform_args!(attrs) ==
               Map.merge(attrs, %{
                 after_cursor: attrs[:after],
                 before_cursor: attrs[:before]
               })
    end
  end
end
