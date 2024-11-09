defmodule JustWeb.GraphQL.Resolvers.Tickets.FindResolver do
  @moduledoc false

  alias Just.Tickets

  def call(%{id: id}, _resolution) do
    Tickets.find(id)
  end
end
