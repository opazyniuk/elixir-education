defmodule PrimitiveBankWeb.Router do
  use PrimitiveBankWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PrimitiveBankWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController

    scope "/bank_operations" do
      get "/", BankOperationController, :index
      get "/charge", BankOperationController, :new_charge
      post "/charge", BankOperationController, :charge
      get "/add", BankOperationController, :new_add
      post "/add", BankOperationController, :add
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PrimitiveBankWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PrimitiveBankWeb.Telemetry
    end
  end
end
