defmodule MagicHome.Repo.Migrations.CreateGpios do
  use Ecto.Migration

  def change do
    create table(:gpios, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :type, :string
      add :number, :integer

      timestamps()
    end

  end
end
