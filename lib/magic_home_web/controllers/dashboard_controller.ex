defmodule MagicHomeWeb.DashboardController do
  use MagicHomeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
