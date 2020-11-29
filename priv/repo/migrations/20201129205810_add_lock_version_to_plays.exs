defmodule Revival.Repo.Migrations.AddLockVersionToPlays do
  use Ecto.Migration

  def change do
    alter table(:plays) do
      add :lock_version, :integer, default: 1
    end
  end
end
