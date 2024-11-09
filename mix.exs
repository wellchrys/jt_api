defmodule Just.MixProject do
  use Mix.Project

  def project do
    [
      app: :just,
      version: "0.1.0",
      elixir: "~> 1.11",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      elixirc_options: [warnings_as_errors: ci?()],
      aliases: aliases(),
      deps: deps(),
      dialyzer: [plt_add_deps: :transitive],
      name: "Just API",
      source_url: "https://github.com/wellchrys/jt_api",
      homepage_url: "https://github.com/wellchrys/jt_api",
      docs: [main: "Just API", extras: ["README.md"]]
    ]
  end

  defp ci?(), do: System.get_env("CI") == "true"

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Just.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.0"},
      {:phoenix_ecto, "~> 4.3"},
      {:ecto_sql, "~> 3.7"},
      {:postgrex, "~> 0.15.9"},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:paginator, "~> 1.0.4"},
      {:telemetry_poller, "~> 0.5"},
      {:ex_money, "~> 5.7"},
      {:phoenix_html, "~> 3.0"},
      {:proper_case, "~> 1.0.2"},
      {:faker, "~> 0.13"},
      {:hammox, "~> 0.5", only: :test},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:httpoison, "~> 1.8"},
      {:excoveralls, "~> 0.14.2"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:bcrypt_elixir, "~> 2.3"},
      {:ex_machina, "~> 2.7.0"},
      {:heartcheck, "~> 0.4.3"},
      {:sobelow, "~> 0.11.1", only: [:dev, :test]},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.25", only: :dev, runtime: false},
      {:hackney, "~> 1.9"},
      {:poison, "~> 3.0"},
      {:sweet_xml, "~> 0.7"},
      {:swoosh, "~> 1.5"},
      {:bypass, "~> 2.1", only: :test},
      {:telemetry, "~> 0.4.3"},
      {:corsica, "~> 1.1.3"},
      {:phoenix_swoosh, "~> 0.3"},
      {:appsignal, "~> 2.2"},
      {:appsignal_phoenix, "~> 2.0"},
      {:timex, "~> 3.7.5"},
      {:absinthe, "~> 1.6"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_phoenix, "~> 2.0"},
      {:guardian, "~> 2.2.0"},
      {:polymorphic_embed, "~> 1.9.0"},
      {:subscriptions_transport_ws, "~> 1.0.0"},
      {:parallel_stream, "~> 1.0.4"},
      {:absinthe_conn_test, "~> 0.1.0"},
      {:number, "~> 1.0.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "code.check": ["format --check-formatted", "credo"]
    ]
  end
end
