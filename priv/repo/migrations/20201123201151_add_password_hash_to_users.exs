defmodule Revival.Repo.Migrations.AddPasswordHashToUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :password_hash, :string, null: false
      modify :id, :uuid, null: false, primary_key: true
      modify :email, :string, null: false
      modify :name, :string, null: false
      remove :provider
    end
  end

  def down do
    alter table(:users) do
      remove :password_hash
      modify :id, :uuid, null: true, primary_key: false
      modify :email, :string, null: true
      modify :name, :string, null: true
      add :provider, :string
    end
  end
end
