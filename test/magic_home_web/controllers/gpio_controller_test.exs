defmodule MagicHomeWeb.GpioControllerTest do
  use MagicHomeWeb.ConnCase

  @create_attrs %{name: "some name", number: 42, type: "input"}
  @update_attrs %{name: "some updated name", number: 43, type: "output"}
  @invalid_attrs %{name: nil, number: nil, type: nil}

  describe "index" do
    test "lists all gpios", %{conn: conn} do
      conn = get(conn, Routes.gpio_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Gpios"
    end
  end

  describe "new gpio" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.gpio_path(conn, :new))
      assert html_response(conn, 200) =~ "New Gpio"
    end
  end

  describe "create gpio" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.gpio_path(conn, :create), gpio: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.gpio_path(conn, :show, id)

      conn = get(conn, Routes.gpio_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Gpio"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.gpio_path(conn, :create), gpio: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Gpio"
    end
  end

  describe "edit gpio" do
    setup [:create_gpio]

    test "renders form for editing chosen gpio", %{conn: conn, gpio: gpio} do
      conn = get(conn, Routes.gpio_path(conn, :edit, gpio))
      assert html_response(conn, 200) =~ "Edit Gpio"
    end
  end

  describe "update gpio" do
    setup [:create_gpio]

    test "redirects when data is valid", %{conn: conn, gpio: gpio} do
      conn = put(conn, Routes.gpio_path(conn, :update, gpio), gpio: @update_attrs)
      assert redirected_to(conn) == Routes.gpio_path(conn, :show, gpio)

      conn = get(conn, Routes.gpio_path(conn, :show, gpio))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, gpio: gpio} do
      conn = put(conn, Routes.gpio_path(conn, :update, gpio), gpio: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Gpio"
    end
  end

  describe "delete gpio" do
    setup [:create_gpio]

    test "deletes chosen gpio", %{conn: conn, gpio: gpio} do
      conn = delete(conn, Routes.gpio_path(conn, :delete, gpio))
      assert redirected_to(conn) == Routes.gpio_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.gpio_path(conn, :show, gpio))
      end)
    end
  end

  defp create_gpio(_) do
    gpio = insert(:gpio)
    {:ok, gpio: gpio}
  end
end
