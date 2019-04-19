defmodule MagicHomeWeb.SensorControllerTest do
  use MagicHomeWeb.ConnCase

  @create_attrs %{name: "some name", type: "fake"}
  @update_attrs %{name: "some updated name", type: "fake"}
  @invalid_attrs %{name: nil, type: nil}

  describe "index" do
    test "lists all sensors", %{conn: conn} do
      conn = get(conn, Routes.sensor_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Sensors"
    end
  end

  describe "new sensor" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.sensor_path(conn, :new))
      assert html_response(conn, 200) =~ "New Sensor"
    end
  end

  describe "create sensor" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.sensor_path(conn, :create), sensor: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.sensor_path(conn, :show, id)

      conn = get(conn, Routes.sensor_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Sensor"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.sensor_path(conn, :create), sensor: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Sensor"
    end
  end

  describe "edit sensor" do
    setup [:create_sensor]

    test "renders form for editing chosen sensor", %{conn: conn, sensor: sensor} do
      conn = get(conn, Routes.sensor_path(conn, :edit, sensor))
      assert html_response(conn, 200) =~ "Edit Sensor"
    end
  end

  describe "update sensor" do
    setup [:create_sensor]

    test "redirects when data is valid", %{conn: conn, sensor: sensor} do
      conn = put(conn, Routes.sensor_path(conn, :update, sensor), sensor: @update_attrs)
      assert redirected_to(conn) == Routes.sensor_path(conn, :show, sensor)

      conn = get(conn, Routes.sensor_path(conn, :show, sensor))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, sensor: sensor} do
      conn = put(conn, Routes.sensor_path(conn, :update, sensor), sensor: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Sensor"
    end
  end

  describe "delete sensor" do
    setup [:create_sensor]

    test "deletes chosen sensor", %{conn: conn, sensor: sensor} do
      conn = delete(conn, Routes.sensor_path(conn, :delete, sensor))
      assert redirected_to(conn) == Routes.sensor_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.sensor_path(conn, :show, sensor))
      end)
    end
  end

  defp create_sensor(_) do
    sensor = insert(:sensor)
    {:ok, sensor: sensor}
  end
end
