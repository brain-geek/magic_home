defmodule MagicHome.Repo.Migrations.CreateProcessRecords do
  use Ecto.Migration

  def change do
    create table(:process_records, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :title, :string
      add :body, :text
      add :active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
