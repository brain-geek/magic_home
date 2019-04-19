defmodule MagicHomeWeb.Router do
  use MagicHomeWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", MagicHomeWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", DashboardController, :index)

    resources("/processes", ProcessRecordController)
    resources("/gpios", GpioController)
    resources("/lamps", LampController)
    resources("/sensors", SensorController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", MagicHomeWeb do
  #   pipe_through :api
  # end
end
