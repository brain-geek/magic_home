defmodule MagicHome.ProcessContext do
  @moduledoc """
  The ProcessContext context.
  """

  import Ecto.Query, warn: false
  alias MagicHome.Repo

  alias MagicHome.ProcessContext.ProcessRecord

  @doc """
  Returns the list of process_records.

  ## Examples

      iex> list_process_records()
      [%ProcessRecord{}, ...]

  """
  def list_process_records do
    Repo.all(ProcessRecord)
  end

  @doc """
  Gets a single process_record.

  Raises `Ecto.NoResultsError` if the Process record does not exist.

  ## Examples

      iex> get_process_record!(123)
      %ProcessRecord{}

      iex> get_process_record!(456)
      ** (Ecto.NoResultsError)

  """
  def get_process_record!(id), do: Repo.get!(ProcessRecord, id)

  @doc """
  Creates a process_record.

  ## Examples

      iex> create_process_record(%{field: value})
      {:ok, %ProcessRecord{}}

      iex> create_process_record(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_process_record(attrs \\ %{}) do
    {status, record} =
      %ProcessRecord{}
      |> ProcessRecord.changeset(attrs)
      |> Repo.insert()

    if status == :ok do
      Application.get_env(:magic_home, :bpm_executor).run(record.id, record.body)
    end

    {status, record}
  end

  @doc """
  Updates a process_record.

  ## Examples

      iex> update_process_record(process_record, %{field: new_value})
      {:ok, %ProcessRecord{}}

      iex> update_process_record(process_record, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_process_record(%ProcessRecord{} = process_record, attrs) do
    {status, record} =
      process_record
      |> ProcessRecord.changeset(attrs)
      |> Repo.update()

    if status == :ok do
      if record.active do
        Application.get_env(:magic_home, :bpm_executor).terminate(record.id)
        Application.get_env(:magic_home, :bpm_executor).run(record.id, record.body)
      else
        ExProcess.ProcessSupervisor.terminate(record.id)
      end
    end

    {status, record}
  end

  @doc """
  Deletes a ProcessRecord.

  ## Examples

      iex> delete_process_record(process_record)
      {:ok, %ProcessRecord{}}

      iex> delete_process_record(process_record)
      {:error, %Ecto.Changeset{}}

  """
  def delete_process_record(%ProcessRecord{} = process_record) do
    {status, record} = Repo.delete(process_record)

    if status == :ok do
      Application.get_env(:magic_home, :bpm_executor).terminate(record.id)
    end

    {status, record}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking process_record changes.

  ## Examples

      iex> change_process_record(process_record)
      %Ecto.Changeset{source: %ProcessRecord{}}

  """
  def change_process_record(%ProcessRecord{} = process_record) do
    ProcessRecord.changeset(process_record, %{})
  end
end
