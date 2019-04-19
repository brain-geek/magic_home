defmodule MagicHome.Repo.Migrations.CreateSensors do
  use Ecto.Migration

  def change do
    create table(:sensors, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :type, :string
      add :gpio_id, references(:gpios, on_delete: :nothing)

      timestamps()
    end

    create index(:sensors, [:gpio_id])
  end
end
