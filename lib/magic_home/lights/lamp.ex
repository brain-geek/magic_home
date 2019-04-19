defmodule MagicHome.Lights.Lamp do
  use MagicHome.Schema
  import Ecto.Changeset

  schema "lamps" do
    field(:name, :string)
    field(:type, :string)
    belongs_to(:gpio, MagicHome.Hardware.Gpio)

    timestamps()
  end

  @doc false
  def changeset(lamp, attrs) do
    changeset =
      lamp
      |> cast(attrs, [:name, :type, :gpio_id])
      |> validate_required([:name, :type])
      |> validate_inclusion(:type, ["fake", "gpio"])

    if changeset.changes[:type] == "gpio" do
      changeset |> validate_required([:gpio_id])
    else
      changeset
    end
  end
end
