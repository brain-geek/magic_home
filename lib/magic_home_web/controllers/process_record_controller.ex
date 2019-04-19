defmodule MagicHomeWeb.ProcessRecordController do
  use MagicHomeWeb, :controller

  alias MagicHome.ProcessContext
  alias MagicHome.ProcessContext.ProcessRecord

  def index(conn, _params) do
    process_records = ProcessContext.list_process_records()
    render(conn, "index.html", process_records: process_records)
  end

  def new(conn, _params) do
    changeset = ProcessContext.change_process_record(%ProcessRecord{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"process_record" => process_record_params}) do
    case ProcessContext.create_process_record(process_record_params) do
      {:ok, process_record} ->
        conn
        |> put_flash(:info, "Process record created successfully.")
        |> redirect(to: Routes.process_record_path(conn, :show, process_record))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    process_record = ProcessContext.get_process_record!(id)
    render(conn, "show.html", process_record: process_record)
  end

  def edit(conn, %{"id" => id}) do
    process_record = ProcessContext.get_process_record!(id)
    changeset = ProcessContext.change_process_record(process_record)
    render(conn, "edit.html", process_record: process_record, changeset: changeset)
  end

  def update(conn, %{"id" => id, "process_record" => process_record_params}) do
    process_record = ProcessContext.get_process_record!(id)

    case ProcessContext.update_process_record(process_record, process_record_params) do
      {:ok, process_record} ->
        conn
        |> put_flash(:info, "Process record updated successfully.")
        |> redirect(to: Routes.process_record_path(conn, :show, process_record))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", process_record: process_record, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    process_record = ProcessContext.get_process_record!(id)
    {:ok, _process_record} = ProcessContext.delete_process_record(process_record)

    conn
    |> put_flash(:info, "Process record deleted successfully.")
    |> redirect(to: Routes.process_record_path(conn, :index))
  end
end
