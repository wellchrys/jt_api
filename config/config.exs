# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

Code.eval_file("./config/dotenv.exs")

config :just,
  ecto_repos: [Just.Repo],
  env: Mix.env()

config :just, Just.Repo, slow_query_threshold_in_ms: 30_000

config :just, JustWeb.Endpoint, pubsub_server: Just.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_money,
  default_cldr_backend: Just.Cldr

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
