defmodule JustWeb.GraphQL.Types.Ticket do
  @moduledoc false

  use Absinthe.Schema.Notation

  object :ticket do
    field(:id, non_null(:id), description: "Ticket's identifier")

    field(:ticket_name, non_null(:string), description: "ticket's name")

    field(:ticket_value, non_null(:decimal), description: "ticket's value")

    field(:ticket_discount_value, non_null(:decimal), description: "ticket discount's value")

    field(:ticket_location, non_null(:string), description: "ticket's location")

    field(:ticket_grade, non_null(:string), description: "ticket's grade")

    field(:ticket_reviews, non_null(:string), description: "ticket's reviews")

    field(:ticket_img, non_null(:string), description: "ticket's image")
  end

  input_object :ticket_filter_options do
    field(:ticket_name, :string, description: "Filter by ticket name")
  end

  object :ticket_connection do
    field(:entries, non_null(list_of(:ticket)), description: "List of tickets")

    field(:before_cursor, :string,
      description:
        "Before cursor of the result, can be passed to the before param in the next query to fetch previous results"
    )

    field(:after_cursor, :string,
      description:
        "After cursor of the result, can be passed to the after param in the next query to fetch next results"
    )
  end
end
