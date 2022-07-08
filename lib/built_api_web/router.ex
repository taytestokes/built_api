defmodule BuiltApiWeb.Router do
  use BuiltApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BuiltApi.Auth.Pipeline
  end

  # Public API Endpoints
  scope "/api", BuiltApiWeb do
    pipe_through :api

    scope "/auth" do
      post "/login", AuthController, :login
      post "/register", AuthController, :register
      get "/refresh", AuthController, :refresh_access_token
    end
  end

  # Protected API Endpouints
  scope "/api", BuiltApiWeb do
    # :auth pipeline will check for access token in the req headers
    pipe_through [:api, :auth]

    scope "/auth" do
      delete "/signout", AuthController, :sign_out
    end
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

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BuiltApiWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
