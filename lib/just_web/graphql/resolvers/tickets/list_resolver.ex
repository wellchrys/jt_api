defmodule JustWeb.GraphQL.Resolvers.Tickets.ListResolver do
  @moduledoc false

  alias Just.Tickets
  alias JustWeb.GraphQL.Paginator

  def call(args, _resolution) do
    args
    |> Paginator.transform_args!()
    |> Tickets.list()
  end
end
