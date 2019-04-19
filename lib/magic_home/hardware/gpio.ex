defmodule MagicHome.Hardware.Gpio do
  use MagicHome.Schema
  import Ecto.Changeset

  schema "gpios" do
    field(:name, :string)
    field(:number, :integer)
    field(:type, :string)

    has_many(:lamps, MagicHome.Lights.Lamp)
    has_many(:sensors, MagicHome.Sensing.Sensor)

    timestamps()
  end

  @doc false
  def changeset(gpio, attrs) do
    gpio
    |> cast(attrs, [:name, :type, :number])
    |> validate_required([:name, :type, :number])
    |> validate_inclusion(:type, ["input", "output"])
  end
end
