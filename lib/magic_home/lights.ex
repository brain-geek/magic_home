defmodule MagicHome.Lights do
  @moduledoc """
  The Lights context.
  """

  import Ecto.Query, warn: false
  alias MagicHome.Repo

  alias MagicHome.Lights.Lamp

  @doc """
  Returns the list of lamps.

  ## Examples

      iex> list_lamps()
      [%Lamp{}, ...]

  """
  def list_lamps do
    Repo.all(Lamp)
  end

  @doc """
  Gets a single lamp.

  Raises `Ecto.NoResultsError` if the Lamp does not exist.

  ## Examples

      iex> get_lamp!(123)
      %Lamp{}

      iex> get_lamp!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lamp!(id), do: Repo.get!(Lamp, id)

  @doc """
  Creates a lamp.

  ## Examples

      iex> create_lamp(%{field: value})
      {:ok, %Lamp{}}

      iex> create_lamp(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lamp(attrs \\ %{}) do
    {status, record} =
      %Lamp{}
      |> Lamp.changeset(attrs)
      |> Repo.insert()

    if status == :ok do
      MagicHome.Lights.LampManager.start(record)
    end

    {status, record}
  end

  @doc """
  Updates a lamp.

  ## Examples

      iex> update_lamp(lamp, %{field: new_value})
      {:ok, %Lamp{}}

      iex> update_lamp(lamp, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lamp(%Lamp{} = lamp, attrs) do
    {status, record} =
      lamp
      |> Lamp.changeset(attrs)
      |> Repo.update()

    if status == :ok do
      MagicHome.Lights.LampManager.terminate(record.id)
      MagicHome.Lights.LampManager.start(record)
    end

    {status, record}
  end

  @doc """
  Deletes a Lamp.

  ## Examples

      iex> delete_lamp(lamp)
      {:ok, %Lamp{}}

      iex> delete_lamp(lamp)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lamp(%Lamp{} = lamp) do
    {status, record} = Repo.delete(lamp)

    if status == :ok do
      MagicHome.Lights.LampManager.terminate(record.id)
    end

    {status, record}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lamp changes.

  ## Examples

      iex> change_lamp(lamp)
      %Ecto.Changeset{source: %Lamp{}}

  """
  def change_lamp(%Lamp{} = lamp) do
    Lamp.changeset(lamp, %{})
  end
end
