defmodule Revival.Repo.Migrations.CreatePlays do
  use Ecto.Migration

  def change do
    create table(:plays, primary_key: false) do
      add :id, :uuid, primay_key: true
      add :mode, :string
      add :round, :integer
      add :board, :map
      add :players, {:array, :map}

      timestamps()
    end
  end
end
