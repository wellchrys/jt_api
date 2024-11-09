defmodule Just.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Just.Supervisor]

    :just
    |> Application.fetch_env!(:env)
    |> children()
    |> Supervisor.start_link(opts)
  end

  defp children(:test), do: default_children()
  defp children(_), do: default_children() ++ runtime_children()

  defp default_children do
    [
      Just.Repo,
      {Phoenix.PubSub, name: Just.PubSub, adapter: Phoenix.PubSub.PG2},
      JustWeb.Endpoint,
      {Absinthe.Subscription, JustWeb.Endpoint}
    ]
  end

  defp runtime_children do
    [
      JustWeb.Telemetry
    ]
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    JustWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
