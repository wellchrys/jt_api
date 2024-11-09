defmodule JustWeb.GraphQL.Middlewares.Auth do
  @moduledoc false

  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution

  @unauthenticated_response {:error,
                             %{
                               message: "Unauthorized",
                               details: "You are not authorized to access this page"
                             }}

  @impl Absinthe.Middleware
  def call(%Resolution{context: context} = resolution, _config) do
    if is_nil(context[:current_user]) do
      Absinthe.Resolution.put_result(resolution, @unauthenticated_response)
    else
      resolution
    end
  end
end
