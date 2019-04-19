defmodule MagicHomeWeb.LampController do
  use MagicHomeWeb, :controller

  alias MagicHome.Lights
  alias MagicHome.Lights.Lamp

  def index(conn, _params) do
    lamps = Lights.list_lamps()
    render(conn, "index.html", lamps: lamps)
  end

  def new(conn, _params) do
    changeset = Lights.change_lamp(%Lamp{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"lamp" => lamp_params}) do
    case Lights.create_lamp(lamp_params) do
      {:ok, lamp} ->
        conn
        |> put_flash(:info, "Lamp created successfully.")
        |> redirect(to: Routes.lamp_path(conn, :show, lamp))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    lamp = Lights.get_lamp!(id)
    render(conn, "show.html", lamp: lamp)
  end

  def edit(conn, %{"id" => id}) do
    lamp = Lights.get_lamp!(id)
    changeset = Lights.change_lamp(lamp)
    render(conn, "edit.html", lamp: lamp, changeset: changeset)
  end

  def update(conn, %{"id" => id, "lamp" => lamp_params}) do
    lamp = Lights.get_lamp!(id)

    case Lights.update_lamp(lamp, lamp_params) do
      {:ok, lamp} ->
        conn
        |> put_flash(:info, "Lamp updated successfully.")
        |> redirect(to: Routes.lamp_path(conn, :show, lamp))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", lamp: lamp, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    lamp = Lights.get_lamp!(id)
    {:ok, _lamp} = Lights.delete_lamp(lamp)

    conn
    |> put_flash(:info, "Lamp deleted successfully.")
    |> redirect(to: Routes.lamp_path(conn, :index))
  end
end
