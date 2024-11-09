defmodule Just.Tickets.TicketTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Just.Tickets.Ticket

  @attrs %{
    ticket_name: Faker.Company.name(),
    ticket_value: 100 |> Faker.random_between(900) |> Decimal.new(),
    ticket_discount_value: 100 |> Faker.random_between(900) |> Decimal.new(),
    ticket_location: Faker.Address.city(),
    ticket_grade: Faker.random_between(1, 10) |> Decimal.new()
  }

  describe "changeset/2" do
    test "should return invalid changeset and errors when missing required fields" do
      %Ecto.Changeset{errors: errors} = Ticket.changeset(%Ticket{}, %{})

      assert [
               {:ticket_name, {"can't be blank", [validation: :required]}},
               {:ticket_value, {"can't be blank", [validation: :required]}},
               {:ticket_discount_value, {"can't be blank", [validation: :required]}},
               {:ticket_location, {"can't be blank", [validation: :required]}},
               {:ticket_grade, {"can't be blank", [validation: :required]}}
             ] == errors
    end

    test "should return valid changeset and properly fulfill it with valid values" do
      %Ecto.Changeset{changes: changes, valid?: valid?} = Ticket.changeset(%Ticket{}, @attrs)

      assert changes == @attrs

      assert valid?
    end

    test "should return invalid changeset and error when ticket name is invalid" do
      attrs = Map.put(@attrs, :ticket_name, 600)

      %Ecto.Changeset{errors: errors} = Ticket.changeset(%Ticket{}, attrs)

      assert errors == [{:ticket_name, {"is invalid", [type: :string, validation: :cast]}}]
    end

    test "should return invalid changeset and error when ticket value is invalid" do
      attrs = Map.put(@attrs, :ticket_value, :wrong_type)

      %Ecto.Changeset{errors: errors} = Ticket.changeset(%Ticket{}, attrs)

      assert errors == [{:ticket_value, {"is invalid", [type: :decimal, validation: :cast]}}]
    end

    test "should return invalid changeset and error when ticket discount value is invalid" do
      attrs = Map.put(@attrs, :ticket_discount_value, "30,3")

      %Ecto.Changeset{errors: errors} = Ticket.changeset(%Ticket{}, attrs)

      assert errors == [
               {:ticket_discount_value, {"is invalid", [type: :decimal, validation: :cast]}}
             ]
    end

    test "should return invalid changeset and error when ticket location is invalid" do
      attrs = Map.put(@attrs, :ticket_location, :wrong_type)

      %Ecto.Changeset{errors: errors} = Ticket.changeset(%Ticket{}, attrs)

      assert errors == [{:ticket_location, {"is invalid", [type: :string, validation: :cast]}}]
    end

    test "should return invalid changeset and error when ticket grade is invalid" do
      attrs = Map.put(@attrs, :ticket_grade, :wrong_type)

      %Ecto.Changeset{errors: errors} = Ticket.changeset(%Ticket{}, attrs)

      assert errors == [{:ticket_grade, {"is invalid", [type: :decimal, validation: :cast]}}]
    end

    test "should return invalid changeset and error fields are nil" do
      %Ecto.Changeset{errors: errors} =
        Ticket.changeset(%Ticket{}, %{
          ticket_name: nil,
          ticket_value: nil,
          ticket_discount_value: nil,
          ticket_location: nil,
          ticket_grade: nil
        })

      assert errors == [
               {:ticket_name, {"can't be blank", [validation: :required]}},
               {:ticket_value, {"can't be blank", [validation: :required]}},
               {:ticket_discount_value, {"can't be blank", [validation: :required]}},
               {:ticket_location, {"can't be blank", [validation: :required]}},
               {:ticket_grade, {"can't be blank", [validation: :required]}}
             ]
    end

    test "should return invalid changeset and error fields are empty" do
      %Ecto.Changeset{errors: errors} =
        Ticket.changeset(%Ticket{}, %{
          ticket_name: "",
          ticket_value: "",
          ticket_discount_value: "",
          ticket_location: "",
          ticket_grade: ""
        })

      assert errors == [
               {:ticket_name, {"can't be blank", [validation: :required]}},
               {:ticket_value, {"can't be blank", [validation: :required]}},
               {:ticket_discount_value, {"can't be blank", [validation: :required]}},
               {:ticket_location, {"can't be blank", [validation: :required]}},
               {:ticket_grade, {"can't be blank", [validation: :required]}}
             ]
    end
  end
end
