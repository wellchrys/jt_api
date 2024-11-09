defmodule Just.Repo do
  use Ecto.Repo,
    otp_app: :just,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
