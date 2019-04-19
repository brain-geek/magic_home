defmodule MagicHomeWeb.GpioController do
  use MagicHomeWeb, :controller

  alias MagicHome.Hardware
  alias MagicHome.Hardware.Gpio

  def index(conn, _params) do
    gpios = Hardware.list_gpios()
    render(conn, "index.html", gpios: gpios)
  end

  def new(conn, _params) do
    changeset = Hardware.change_gpio(%Gpio{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"gpio" => gpio_params}) do
    case Hardware.create_gpio(gpio_params) do
      {:ok, gpio} ->
        conn
        |> put_flash(:info, "Gpio created successfully.")
        |> redirect(to: Routes.gpio_path(conn, :show, gpio))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    gpio = Hardware.get_gpio!(id)
    render(conn, "show.html", gpio: gpio)
  end

  def edit(conn, %{"id" => id}) do
    gpio = Hardware.get_gpio!(id)
    changeset = Hardware.change_gpio(gpio)
    render(conn, "edit.html", gpio: gpio, changeset: changeset)
  end

  def update(conn, %{"id" => id, "gpio" => gpio_params}) do
    gpio = Hardware.get_gpio!(id)

    case Hardware.update_gpio(gpio, gpio_params) do
      {:ok, gpio} ->
        conn
        |> put_flash(:info, "Gpio updated successfully.")
        |> redirect(to: Routes.gpio_path(conn, :show, gpio))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", gpio: gpio, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    gpio = Hardware.get_gpio!(id)
    {:ok, _gpio} = Hardware.delete_gpio(gpio)

    conn
    |> put_flash(:info, "Gpio deleted successfully.")
    |> redirect(to: Routes.gpio_path(conn, :index))
  end
end
