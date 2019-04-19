defmodule MagicHome.Repo.Migrations.CreateLamps do
  use Ecto.Migration

  def change do
    create table(:lamps, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :type, :string
      add(:gpio_id, references(:gpios, on_delete: :nothing), type: :uuid)

      timestamps()
    end

    create index(:lamps, [:gpio_id])
  end
end
