defmodule JustWeb.GraphQL.ContextUtils do
  @moduledoc false

  import Plug.Conn

  def build_context(conn, guardian) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, %{"sub" => _} = decode} <- guardian.decode_and_verify(token),
         {:ok, user} <- guardian.resource_from_claims(decode) do
      %{current_user: %{id: user.id}}
    else
      _ -> %{}
    end
  end
end
