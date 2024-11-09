defmodule Just.Tickets.Ticket do
  @moduledoc """
    Schema definition for a Ticket.
  """

  use Ecto.Schema
  import Ecto.Changeset, only: [cast: 3, validate_required: 2, unique_constraint: 3]

  @type t :: %__MODULE__{
          id: pos_integer(),
          ticket_name: String.t(),
          ticket_value: Decimal.t(),
          ticket_discount_value: Decimal.t(),
          ticket_location: String.t(),
          ticket_grade: Decimal.t(),
          ticket_reviews: pos_integer(),
          ticket_img: String.t()
        }

  schema "tickets" do
    field(:ticket_name, :string, null: false)
    field(:ticket_value, :decimal, null: false)
    field(:ticket_discount_value, :decimal, null: false)
    field(:ticket_location, :string, null: false)
    field(:ticket_grade, :decimal, null: false)
    field(:ticket_reviews, :integer, null: false)
    field(:ticket_img, :string, null: false)

    timestamps()
  end

  @fields [
    :ticket_name,
    :ticket_value,
    :ticket_discount_value,
    :ticket_location,
    :ticket_grade,
    :ticket_reviews,
    :ticket_img
  ]

  @existing_ticket_message_error "Ticket with this name has already been added!"

  def changeset(%__MODULE__{} = ticket, attrs) do
    ticket
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> unique_constraint(@fields,
      name: :unique_ticket_by_ticket_name,
      message: @existing_ticket_message_error
    )
  end
end
