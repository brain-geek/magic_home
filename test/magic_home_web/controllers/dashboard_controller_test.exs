defmodule MagicHomeWeb.PageControllerTest do
  use MagicHomeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Dashboard"
  end
end
