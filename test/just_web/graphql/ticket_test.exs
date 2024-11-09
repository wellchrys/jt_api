defmodule JustWeb.GraphQL.TicketTest do
  @moduledoc false

  use JustWeb.ConnCase, async: true

  import Just.Factory

  @ticket_query """
  query ticket($id: ID!) {
    ticket(id: $id) {
      id,
      ticketName,
      ticketValue
      ticketDiscountValue
      ticketLocation
      ticketGrade
    }
  }
  """

  describe "query: ticket" do
    test "should return an error when a ticket is not found for the given id", %{
      conn: conn
    } do
      response =
        conn
        |> post("/graphql", %{
          query: @ticket_query,
          variables: %{id: Faker.random_between(1, 10)}
        })
        |> json_response(200)

      assert %{
               "data" => %{"ticket" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 3, "line" => 2}],
                   "message" => "ticket_not_found",
                   "path" => ["ticket"]
                 }
               ]
             } ==
               response
    end

    test "should return error when missing required fields", %{conn: conn} do
      response =
        conn
        |> post("/graphql", %{
          query: @ticket_query,
          variables: %{}
        })
        |> json_response(200)

      assert %{
               "errors" => [
                 %{
                   "locations" => [%{"column" => 10, "line" => 2}],
                   "message" => "In argument \"id\": Expected type \"ID!\", found null."
                 },
                 %{
                   "locations" => [%{"column" => 14, "line" => 1}],
                   "message" => "Variable \"id\": Expected non-null, found null."
                 }
               ]
             } == response
    end

    test "should successfully return a ticket for the given id", %{
      conn: conn
    } do
      ticket = insert(:ticket)

      response =
        conn
        |> post("/graphql", %{
          query: @ticket_query,
          variables: %{id: ticket.id}
        })
        |> json_response(200)

      assert response == %{
               "data" => %{
                 "ticket" => %{
                   "id" => "#{ticket.id}",
                   "ticketDiscountValue" => "#{ticket.ticket_discount_value}",
                   "ticketGrade" => "#{ticket.ticket_grade}",
                   "ticketLocation" => ticket.ticket_location,
                   "ticketName" => ticket.ticket_name,
                   "ticketValue" => "#{ticket.ticket_value}"
                 }
               }
             }
    end
  end
end
