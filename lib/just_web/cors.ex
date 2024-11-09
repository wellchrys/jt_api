defmodule JustWeb.CORS do
  @moduledoc """
    Expose Cors functionality
  """

  use Corsica.Router,
    origins: {__MODULE__, :check_origin},
    allow_credentials: true,
    log: [rejected: :error],
    max_age: 600,
    allow_methods: ["GET", "POST"],
    allow_headers: ["content-type", "authorization", "x-requested-with"]

  resource("/graphql/*")

  def check_origin(origin) do
    Application.get_env(:just, :env) == :dev or String.match?(origin, ~r/\.mydomain\.com\.br/)
  end
end
