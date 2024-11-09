defmodule JustWeb.GraphQL.Plugs.Context do
  @moduledoc false

  alias Just.Guardian
  alias JustWeb.GraphQL.ContextUtils

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _) do
    context = ContextUtils.build_context(conn, Guardian)
    initial_context = conn.private[:absinthe][:context] || %{}
    context = Map.merge(initial_context, context)

    Absinthe.Plug.put_options(conn, context: context)
  end
end
