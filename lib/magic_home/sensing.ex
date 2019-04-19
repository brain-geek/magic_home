defmodule MagicHome.Sensing do
  @moduledoc """
  The Sensing context.
  """

  import Ecto.Query, warn: false
  alias MagicHome.Repo

  alias MagicHome.Sensing.Sensor

  @doc """
  Returns the list of sensors.

  ## Examples

      iex> list_sensors()
      [%Sensor{}, ...]

  """
  def list_sensors do
    Repo.all(Sensor)
  end

  @doc """
  Gets a single sensor.

  Raises `Ecto.NoResultsError` if the Sensor does not exist.

  ## Examples

      iex> get_sensor!(123)
      %Sensor{}

      iex> get_sensor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sensor!(id), do: Repo.get!(Sensor, id)

  @doc """
  Creates a sensor.

  ## Examples

      iex> create_sensor(%{field: value})
      {:ok, %Sensor{}}

      iex> create_sensor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sensor(attrs \\ %{}) do
    {status, record} =
      %Sensor{}
      |> Sensor.changeset(attrs)
      |> Repo.insert()

    if status == :ok do
      MagicHome.Sensing.SensorManager.start(record)
    end

    {status, record}
  end

  @doc """
  Updates a sensor.

  ## Examples

      iex> update_sensor(sensor, %{field: new_value})
      {:ok, %Sensor{}}

      iex> update_sensor(sensor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sensor(%Sensor{} = sensor, attrs) do
    {status, record} =
      sensor
      |> Sensor.changeset(attrs)
      |> Repo.update()

    if status == :ok do
      MagicHome.Sensing.SensorManager.terminate(record.id)
      MagicHome.Sensing.SensorManager.start(record)
    end

    {status, record}
  end

  @doc """
  Deletes a Sensor.

  ## Examples

      iex> delete_sensor(sensor)
      {:ok, %Sensor{}}

      iex> delete_sensor(sensor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sensor(%Sensor{} = sensor) do
    {status, record} = Repo.delete(sensor)

    if status == :ok do
      MagicHome.Sensing.SensorManager.terminate(record.id)
    end

    {status, record}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sensor changes.

  ## Examples

      iex> change_sensor(sensor)
      %Ecto.Changeset{source: %Sensor{}}

  """
  def change_sensor(%Sensor{} = sensor) do
    Sensor.changeset(sensor, %{})
  end
end
