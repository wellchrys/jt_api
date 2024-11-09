defmodule JustWeb.GraphQL.Types.RootQuery do
  @moduledoc false

  use Absinthe.Schema.Notation

  alias JustWeb.GraphQL.Resolvers.Tickets

  import_types(JustWeb.GraphQL.Types.Ticket)

  object :root_query do
    field :ticket,
      type: :ticket do
      description("A single ticket account")

      arg(:id, non_null(:id), description: "Ticket's identifier")

      resolve(&Tickets.FindResolver.call/2)
    end

    field :tickets,
      type: :ticket_connection do
      description("List tickets")

      arg(:after, :string, description: "After pagination cursor")
      arg(:before, :string, description: "Before pagination cursor")

      arg(:page_size, :integer,
        description: "Number of items returned per page. Default: 10. Max: 10_000."
      )

      arg(:maximum_limit, :integer,
        description: "Number of items returned by the query. Default: 100. Max: 10_000."
      )

      arg(:filters, :ticket_filter_options, description: "Ticket filter options")

      resolve(&Tickets.ListResolver.call/2)
    end
  end
end
