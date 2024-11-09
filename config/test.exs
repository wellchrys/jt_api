import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :just, Just.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.fetch_env!("JUST_POSTGRESQL_URL"),
  pool: Ecto.Adapters.SQL.Sandbox,
  queue_target: 1_000,
  queue_interval: 5_000

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :just, JustWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
