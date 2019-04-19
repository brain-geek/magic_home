defmodule MagicHome.Sensing.Sensor do
  use MagicHome.Schema
  import Ecto.Changeset

  schema "sensors" do
    field(:name, :string)
    field(:type, :string)
    belongs_to(:gpio, MagicHome.Hardware.Gpio)

    timestamps()
  end

  @doc false
  def changeset(sensor, attrs) do
    changeset = sensor
    |> cast(attrs, [:name, :type, :gpio_id])
    |> validate_required([:name, :type])
    |> validate_inclusion(:type, ["fake", "gpio_switch"])

    if changeset.changes[:type] == "gpio_switch" do
      changeset |> validate_required([:gpio_id])
    else
      changeset
    end
  end
end
