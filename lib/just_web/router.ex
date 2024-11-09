defmodule JustWeb.Router do
  use JustWeb, :router

  pipeline :browser do
    plug(
      :put_secure_browser_headers,
      %{"content-security-policy" => "default-src 'self'"}
    )

    plug(:fetch_session)
    plug(:protect_from_forgery)
    plug(:accepts, ["html"])
  end

  pipeline :private_browser do
    plug(:fetch_session)
    plug(:protect_from_forgery)
    plug(:accepts, ["html"])
  end

  pipeline :graphql do
    plug(JustWeb.GraphQL.Plugs.Context)
  end

  pipeline :monitoring do
    plug(:accepts, ["json"])
  end

  scope "/graphql" do
    pipe_through(:graphql)

    forward("/", Absinthe.Plug, schema: JustWeb.GraphQL.Schema)
  end

  scope "/monitoring" do
    pipe_through(:monitoring)

    forward("/heart-check", HeartCheck.Plug, heartcheck: JustWeb.HeartCheck)
    forward("/health-check", JustWeb.Plugs.HealthCheck)
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    pipeline :graphiql do
    end

    scope "/graphiql" do
      pipe_through(:graphiql)

      forward("/", Absinthe.Plug.GraphiQL,
        schema: JustWeb.GraphQL.Schema,
        interface: :playground,
        context: %{pubsub: JustWeb.Endpoint}
      )
    end

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: JustWeb.Telemetry)
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through([:browser])

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
