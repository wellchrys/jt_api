defmodule JustWeb.GraphQL.Resolvers.Tickets.FindResolverTest do
  @moduledoc false

  use JustWeb.ConnCase, async: true

  import Just.Factory

  alias JustWeb.GraphQL.Resolvers.Tickets.FindResolver

  describe "call/2" do
    test "return ticket when it is found" do
      ticket = insert(:ticket)

      {:ok, actual_ticket} = FindResolver.call(%{id: ticket.id}, %{})

      assert ticket.ticket_name == actual_ticket.ticket_name

      assert ticket.ticket_value == actual_ticket.ticket_value

      assert ticket.ticket_discount_value == actual_ticket.ticket_discount_value

      assert ticket.ticket_location == actual_ticket.ticket_location

      assert ticket.ticket_grade == actual_ticket.ticket_grade
    end

    test "return error when ticket is not found" do
      assert {:error, :ticket_not_found} ==
               FindResolver.call(%{id: Faker.random_between(1, 10)}, %{})
    end
  end
end
