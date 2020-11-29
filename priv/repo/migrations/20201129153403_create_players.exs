defmodule Revival.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :uuid, primay_key: true
      add :user_id, references(:users, type: :uuid)
      add :name, :string
      add :rank, :integer

      timestamps()
    end
  end
end
