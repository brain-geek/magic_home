defmodule MagicHome.Hardware do
  @moduledoc """
  The Hardware context.
  """

  import Ecto.Query, warn: false
  alias MagicHome.Repo

  alias MagicHome.Hardware.Gpio

  @doc """
  Returns the list of gpios.

  ## Examples

      iex> list_gpios()
      [%Gpio{}, ...]

  """
  def list_gpios do
    Repo.all(Gpio)
  end

  # TODO: add tests for this
  # TODO: add input/output switch as parameter

  def list_gpios_for_dropdown do
    Repo.all(from(g in Gpio, select: {g.name, g.id}))
  end

  @doc """
  Gets a single gpio.

  Raises `Ecto.NoResultsError` if the Gpio does not exist.

  ## Examples

      iex> get_gpio!(123)
      %Gpio{}

      iex> get_gpio!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gpio!(id), do: Repo.get!(Gpio, id)

  @doc """
  Creates a gpio.

  ## Examples

      iex> create_gpio(%{field: value})
      {:ok, %Gpio{}}

      iex> create_gpio(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gpio(attrs \\ %{}) do
    %Gpio{}
    |> Gpio.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gpio.

  ## Examples

      iex> update_gpio(gpio, %{field: new_value})
      {:ok, %Gpio{}}

      iex> update_gpio(gpio, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gpio(%Gpio{} = gpio, attrs) do
    gpio
    |> Gpio.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Gpio.

  ## Examples

      iex> delete_gpio(gpio)
      {:ok, %Gpio{}}

      iex> delete_gpio(gpio)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gpio(%Gpio{} = gpio) do
    Repo.delete(gpio)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gpio changes.

  ## Examples

      iex> change_gpio(gpio)
      %Ecto.Changeset{source: %Gpio{}}

  """
  def change_gpio(%Gpio{} = gpio) do
    Gpio.changeset(gpio, %{})
  end
end
