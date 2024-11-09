defmodule JustWeb.Plugs.Absinthe.GraphiQL do
  @moduledoc """
    wrapper plug as an workaround for Phoenix routings
  """

  defdelegate init(opts), to: Absinthe.Plug.GraphiQL
  defdelegate call(conn, opts), to: Absinthe.Plug.GraphiQL
end
