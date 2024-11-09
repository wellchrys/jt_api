defmodule JustWeb.GraphQL.TicketsTest do
  @moduledoc false

  # credo:disable-for-this-file Credo.Check.Design.DuplicatedCode

  use JustWeb.ConnCase, async: true

  import Just.Factory

  @tickets_query """
  query tickets($after: String, $before: String, $pageSize: Int, $filters: TicketFilterOptions) {
    tickets(after: $after, before: $before, pageSize: $pageSize, filters: $filters) {
        entries{
          id,
          ticketName,
          ticketValue
          ticketDiscountValue
          ticketLocation
          ticketGrade
      },
      beforeCursor
      afterCursor
    }
  }
  """

  describe "query: tickets" do
    test "should successfully return a list of tickets without pagination",
         %{
           conn: conn
         } do
      ticket_one = insert(:ticket)

      ticket_two = insert(:ticket)

      ticket_three = insert(:ticket)

      response =
        conn
        |> post("/graphql", %{
          query: @tickets_query,
          variables: %{
            after: nil,
            before: nil,
            pageSize: nil,
            filters: %{}
          }
        })
        |> json_response(200)

      assert %{
               "data" => %{
                 "tickets" => %{
                   "afterCursor" => nil,
                   "beforeCursor" => nil,
                   "entries" => [
                     %{
                       "id" => "#{ticket_three.id}",
                       "ticketName" => ticket_three.ticket_name,
                       "ticketDiscountValue" => "#{ticket_three.ticket_discount_value}",
                       "ticketGrade" => "#{ticket_three.ticket_grade}",
                       "ticketLocation" => ticket_three.ticket_location,
                       "ticketValue" => "#{ticket_three.ticket_value}"
                     },
                     %{
                       "id" => "#{ticket_two.id}",
                       "ticketName" => ticket_two.ticket_name,
                       "ticketDiscountValue" => "#{ticket_two.ticket_discount_value}",
                       "ticketGrade" => "#{ticket_two.ticket_grade}",
                       "ticketLocation" => ticket_two.ticket_location,
                       "ticketValue" => "#{ticket_two.ticket_value}"
                     },
                     %{
                       "id" => "#{ticket_one.id}",
                       "ticketName" => ticket_one.ticket_name,
                       "ticketDiscountValue" => "#{ticket_one.ticket_discount_value}",
                       "ticketGrade" => "#{ticket_one.ticket_grade}",
                       "ticketLocation" => ticket_one.ticket_location,
                       "ticketValue" => "#{ticket_one.ticket_value}"
                     }
                   ]
                 }
               }
             } ==
               response
    end

    test "should successfully return a list of tickets with pagination", %{
      conn: conn
    } do
      ticket_one = insert(:ticket)

      ticket_two = insert(:ticket)

      ticket_three = insert(:ticket)

      response =
        conn
        |> post("/graphql", %{
          query: @tickets_query,
          variables: %{after: nil, before: nil, pageSize: 2, filters: %{}}
        })
        |> json_response(200)

      after_cursor = response["data"]["tickets"]["afterCursor"]

      assert after_cursor

      assert %{
               "data" => %{
                 "tickets" => %{
                   "afterCursor" => after_cursor,
                   "beforeCursor" => nil,
                   "entries" => [
                     %{
                       "id" => "#{ticket_three.id}",
                       "ticketName" => ticket_three.ticket_name,
                       "ticketDiscountValue" => "#{ticket_three.ticket_discount_value}",
                       "ticketGrade" => "#{ticket_three.ticket_grade}",
                       "ticketLocation" => ticket_three.ticket_location,
                       "ticketValue" => "#{ticket_three.ticket_value}"
                     },
                     %{
                       "id" => "#{ticket_two.id}",
                       "ticketName" => ticket_two.ticket_name,
                       "ticketDiscountValue" => "#{ticket_two.ticket_discount_value}",
                       "ticketGrade" => "#{ticket_two.ticket_grade}",
                       "ticketLocation" => ticket_two.ticket_location,
                       "ticketValue" => "#{ticket_two.ticket_value}"
                     }
                   ]
                 }
               }
             } ==
               response

      response =
        conn
        |> post("/graphql", %{
          query: @tickets_query,
          variables: %{after: after_cursor, pageSize: 2}
        })
        |> json_response(200)

      before_cursor = response["data"]["tickets"]["beforeCursor"]

      assert before_cursor

      assert response == %{
               "data" => %{
                 "tickets" => %{
                   "afterCursor" => nil,
                   "beforeCursor" => before_cursor,
                   "entries" => [
                     %{
                       "id" => "#{ticket_one.id}",
                       "ticketName" => ticket_one.ticket_name,
                       "ticketDiscountValue" => "#{ticket_one.ticket_discount_value}",
                       "ticketGrade" => "#{ticket_one.ticket_grade}",
                       "ticketLocation" => ticket_one.ticket_location,
                       "ticketValue" => "#{ticket_one.ticket_value}"
                     }
                   ]
                 }
               }
             }
    end

    test "should return an empty ticket's list when tickets are not found",
         %{conn: conn} do
      response =
        conn
        |> post("/graphql", %{
          query: @tickets_query,
          variables: %{after: nil, before: nil, pageSize: nil, filters: %{}}
        })
        |> json_response(200)

      assert %{
               "data" => %{
                 "tickets" => %{"afterCursor" => nil, "beforeCursor" => nil, "entries" => []}
               }
             } ==
               response
    end
  end
end
