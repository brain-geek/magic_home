defmodule MagicHomeWeb.LampControllerTest do
  use MagicHomeWeb.ConnCase

  @create_attrs %{name: "some name", type: "fake"}
  @update_attrs %{name: "some updated name", type: "fake"}
  @invalid_attrs %{name: nil, type: nil}

  describe "index" do
    test "lists all lamps", %{conn: conn} do
      conn = get(conn, Routes.lamp_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Lamps"
    end
  end

  describe "new lamp" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.lamp_path(conn, :new))
      assert html_response(conn, 200) =~ "New Lamp"
    end
  end

  describe "create lamp" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.lamp_path(conn, :create), lamp: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.lamp_path(conn, :show, id)

      conn = get(conn, Routes.lamp_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Lamp"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.lamp_path(conn, :create), lamp: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Lamp"
    end
  end

  describe "edit lamp" do
    setup [:create_lamp]

    test "renders form for editing chosen lamp", %{conn: conn, lamp: lamp} do
      conn = get(conn, Routes.lamp_path(conn, :edit, lamp))
      assert html_response(conn, 200) =~ "Edit Lamp"
    end
  end

  describe "update lamp" do
    setup [:create_lamp]

    test "redirects when data is valid", %{conn: conn, lamp: lamp} do
      conn = put(conn, Routes.lamp_path(conn, :update, lamp), lamp: @update_attrs)
      assert redirected_to(conn) == Routes.lamp_path(conn, :show, lamp)

      conn = get(conn, Routes.lamp_path(conn, :show, lamp))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, lamp: lamp} do
      conn = put(conn, Routes.lamp_path(conn, :update, lamp), lamp: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Lamp"
    end
  end

  describe "delete lamp" do
    setup [:create_lamp]

    test "deletes chosen lamp", %{conn: conn, lamp: lamp} do
      conn = delete(conn, Routes.lamp_path(conn, :delete, lamp))
      assert redirected_to(conn) == Routes.lamp_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.lamp_path(conn, :show, lamp))
      end)
    end
  end

  defp create_lamp(_) do
    lamp = insert(:lamp)
    {:ok, lamp: lamp}
  end
end
