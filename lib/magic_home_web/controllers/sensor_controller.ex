defmodule MagicHomeWeb.SensorController do
  use MagicHomeWeb, :controller

  alias MagicHome.Sensing
  alias MagicHome.Sensing.Sensor

  def index(conn, _params) do
    sensors = Sensing.list_sensors()
    render(conn, "index.html", sensors: sensors)
  end

  def new(conn, _params) do
    changeset = Sensing.change_sensor(%Sensor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sensor" => sensor_params}) do
    case Sensing.create_sensor(sensor_params) do
      {:ok, sensor} ->
        conn
        |> put_flash(:info, "Sensor created successfully.")
        |> redirect(to: Routes.sensor_path(conn, :show, sensor))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sensor = Sensing.get_sensor!(id)
    render(conn, "show.html", sensor: sensor)
  end

  def edit(conn, %{"id" => id}) do
    sensor = Sensing.get_sensor!(id)
    changeset = Sensing.change_sensor(sensor)
    render(conn, "edit.html", sensor: sensor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sensor" => sensor_params}) do
    sensor = Sensing.get_sensor!(id)

    case Sensing.update_sensor(sensor, sensor_params) do
      {:ok, sensor} ->
        conn
        |> put_flash(:info, "Sensor updated successfully.")
        |> redirect(to: Routes.sensor_path(conn, :show, sensor))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", sensor: sensor, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sensor = Sensing.get_sensor!(id)
    {:ok, _sensor} = Sensing.delete_sensor(sensor)

    conn
    |> put_flash(:info, "Sensor deleted successfully.")
    |> redirect(to: Routes.sensor_path(conn, :index))
  end
end
