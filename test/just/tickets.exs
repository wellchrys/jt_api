defmodule Just.TicketsTest do
  @moduledoc false

  use Just.DataCase, async: true

  import Just.Factory

  alias Just.Tickets

  describe "list/1" do
    @list_attrs %{
      before_cursor: nil,
      after_cursor: nil,
      page_size: nil,
      maximum_limit: nil,
      filters: %{}
    }

    test "should return empty list when no tickets found" do
      assert Tickets.list(@list_attrs) ==
               {:ok, %{entries: [], before_cursor: nil, after_cursor: nil}}
    end

    test "should return found tickets without pagination" do
      first_ticket = insert(:ticket)

      second_ticket = insert(:ticket)

      third_ticket = insert(:ticket)

      {:ok, %{entries: tickets}} = Tickets.list(@list_attrs)

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
       }} = Tickets.list(attrs)

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

      attrs = Map.put(attrs, :after_cursor, first_after_cursor)

      {:ok,
       %{
         after_cursor: nil,
         before_cursor: before_cursor,
         entries: tickets_second_page
       }} = Tickets.list(attrs)

      assert [actual_first_ticket] = tickets_second_page

      assert first_ticket.ticket_name == actual_first_ticket.ticket_name

      assert first_ticket.ticket_value == actual_first_ticket.ticket_value

      assert first_ticket.ticket_discount_value == actual_first_ticket.ticket_discount_value

      assert first_ticket.ticket_location == actual_first_ticket.ticket_location

      assert first_ticket.ticket_grade == actual_first_ticket.ticket_grade

      assert before_cursor, "should fill before cursor"

      attrs = Map.merge(attrs, %{before_cursor: before_cursor, after_cursor: nil})

      {:ok,
       %{
         after_cursor: after_cursor,
         before_cursor: nil,
         entries: tickets_first_page
       }} = Tickets.list(attrs)

      assert [third_ticket, second_ticket] = tickets_first_page

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

  describe "find/1" do
    test "return ticket when it is found" do
      ticket = insert(:ticket)

      {:ok, actual_ticket} = Tickets.find(ticket.id)

      assert ticket.ticket_name == actual_ticket.ticket_name

      assert ticket.ticket_value == actual_ticket.ticket_value

      assert ticket.ticket_discount_value == actual_ticket.ticket_discount_value

      assert ticket.ticket_location == actual_ticket.ticket_location

      assert ticket.ticket_grade == actual_ticket.ticket_grade
    end

    test "return error when ticket is not found" do
      assert {:error, :ticket_not_found} == Tickets.find(Faker.random_between(1, 10))
    end
  end
end
