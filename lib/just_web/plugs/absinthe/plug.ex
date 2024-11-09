defmodule JustWeb.Plugs.Absinthe.Plug do
  @moduledoc """
    wrapper plug as an workaround for Phoenix routings
  """

  defdelegate init(opts), to: Absinthe.Plug
  defdelegate call(conn, opts), to: Absinthe.Plug
end
