defmodule JustWeb.Plugs.HealthCheck do
  @moduledoc false

  @behaviour Plug

  import Plug.Conn

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    conn
    |> put_status(:no_content)
    |> put_resp_header("content-type", "application/json")
    |> send_resp(204, "")
    |> halt()
  end
end
