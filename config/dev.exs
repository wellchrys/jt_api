import Config

config :just, Just.Repo,
  url: System.fetch_env!("JUST_POSTGRESQL_URL"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :just, JustWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [],
  url: [host: "localhost"],
  secret_key_base: "SyaqsnvCNcV7WTThwZRbSr8qWu6neQs4IVuTnAGGCnkEZohaMp3l56Z/DYkOGe8X",
  render_errors: [view: JustWeb.ErrorView, accepts: ~w(json), layout: false],
  live_view: [signing_salt: "53Ya68l+"]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :swoosh, serve_mailbox: true
config :swoosh, serve_mailbox: true, preview_port: 4001
