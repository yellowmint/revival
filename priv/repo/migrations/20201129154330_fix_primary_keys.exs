defmodule Revival.Repo.Migrations.FixPrimaryKeys do
  use Ecto.Migration

  def up do
    alter table(:plays) do
      modify :id, :uuid, null: false, primary_key: true
    end
    alter table(:players) do
      modify :id, :uuid, null: false, primary_key: true
    end
  end

  def down do
    alter table(:plays) do
      modify :id, :uuid, null: true, primary_key: false
    end
    alter table(:players) do
      modify :id, :uuid, null: true, primary_key: false
    end
  end
end
