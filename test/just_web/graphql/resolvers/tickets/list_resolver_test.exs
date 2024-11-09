defmodule JustWeb.GraphQL.Resolvers.Tickets.ListResolverTest do
  @moduledoc false

  use JustWeb.ConnCase, async: true

  import Just.Factory

  alias JustWeb.GraphQL.Resolvers.Tickets.ListResolver

  describe "call/2" do
    @list_attrs %{
      before: nil,
      after: nil,
      page_size: nil,
      maximum_limit: nil,
      filters: %{}
    }

    test "should return empty list when no tickets found" do
      assert ListResolver.call(@list_attrs, %{}) ==
               {:ok, %{entries: [], before_cursor: nil, after_cursor: nil}}
    end

    test "should return found tickets without pagination" do
      first_ticket = insert(:ticket)

      second_ticket = insert(:ticket)

      third_ticket = insert(:ticket)

      {:ok, %{entries: tickets}} = ListResolver.call(@list_attrs, %{})

      [actual_third_ticket, actual_second_ticket, actual_first_ticket] = tickets

      assert third_ticket.ticket_name == actual_third_ticket.ticket_name

      assert third_ticket.ticket_value == actual_third_ticket.ticket_value

      assert third_ticket.ticket_discount_value == actual_third_ticket.ticket_discount_value

      assert third_ticket.ticket_location == actual_third_ticket.ticket_location

      assert third_ticket.ticket_grade == actual_third_ticket.ticket_grade

      assert second_ticket.ticket_name == actual_second_ticket.ticket_name

      assert second_ticket.ticket_value == actual_second_ticket.ticket_value

      assert second_ticket.ticket_discount_value == actual_second_ticket.ticket_discount_value

      assert second_ticket.ticket_location == actual_second_ticket.ticket_location

      assert second_ticket.ticket_grade == actual_second_ticket.ticket_grade

      assert first_ticket.ticket_name == actual_first_ticket.ticket_name

      assert first_ticket.ticket_value == actual_first_ticket.ticket_value

      assert first_ticket.ticket_discount_value == actual_first_ticket.ticket_discount_value

      assert first_ticket.ticket_location == actual_first_ticket.ticket_location

      assert first_ticket.ticket_grade == actual_first_ticket.ticket_grade
    end

    test "should return found tickets with pagination" do
      attrs = Map.put(@list_attrs, :page_size, 2)

      first_ticket = insert(:ticket)

      second_ticket = insert(:ticket)

      third_ticket = insert(:ticket)

      {:ok,
       %{
         after_cursor: first_after_cursor,
         before_cursor: nil,
         entries: tickets_first_page
       }} = ListResolver.call(attrs, %{})

      assert [actual_third_ticket, actual_second_ticket] = tickets_first_page

      assert third_ticket.ticket_name == actual_third_ticket.ticket_name

      assert third_ticket.ticket_value == actual_third_ticket.ticket_value

      assert third_ticket.ticket_discount_value == actual_third_ticket.ticket_discount_value

      assert third_ticket.ticket_location == actual_third_ticket.ticket_location

      assert third_ticket.ticket_grade == actual_third_ticket.ticket_grade

      assert second_ticket.ticket_name == actual_second_ticket.ticket_name

      assert second_ticket.ticket_value == actual_second_ticket.ticket_value

      assert second_ticket.ticket_discount_value == actual_second_ticket.ticket_discount_value

      assert second_ticket.ticket_location == actual_second_ticket.ticket_location

      assert second_ticket.ticket_grade == actual_second_ticket.ticket_grade

      assert first_after_cursor, "should fill after cursor"

      attrs = Map.put(attrs, :after, first_after_cursor)

      {:ok,
       %{
         after_cursor: nil,
         before_cursor: before_cursor,
         entries: tickets_second_page
       }} = ListResolver.call(attrs, %{})

      assert [actual_first_ticket] = tickets_second_page

      assert first_ticket.ticket_name == actual_first_ticket.ticket_name

      assert first_ticket.ticket_value == actual_first_ticket.ticket_value

      assert first_ticket.ticket_discount_value == actual_first_ticket.ticket_discount_value

      assert first_ticket.ticket_location == actual_first_ticket.ticket_location

      assert first_ticket.ticket_grade == actual_first_ticket.ticket_grade

      assert before_cursor, "should fill before cursor"

      attrs = Map.merge(attrs, %{before: before_cursor, after: nil})

      {:ok,
       %{
         after_cursor: after_cursor,
         before_cursor: nil,
         entries: tickets_first_page
       }} = ListResolver.call(attrs, %{})

      assert [actual_third_ticket, actual_second_ticket] = tickets_first_page
      assert third_ticket.ticket_name == actual_third_ticket.ticket_name

      assert third_ticket.ticket_value == actual_third_ticket.ticket_value

      assert third_ticket.ticket_discount_value == actual_third_ticket.ticket_discount_value

      assert third_ticket.ticket_location == actual_third_ticket.ticket_location

      assert third_ticket.ticket_grade == actual_third_ticket.ticket_grade

      assert second_ticket.ticket_name == actual_second_ticket.ticket_name

      assert second_ticket.ticket_value == actual_second_ticket.ticket_value

      assert second_ticket.ticket_discount_value == actual_second_ticket.ticket_discount_value

      assert second_ticket.ticket_location == actual_second_ticket.ticket_location

      assert second_ticket.ticket_grade == actual_second_ticket.ticket_grade

      assert after_cursor == first_after_cursor
    end
  end
end
