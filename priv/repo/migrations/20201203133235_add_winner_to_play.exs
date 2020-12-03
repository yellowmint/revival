defmodule Revival.Repo.Migrations.AddWinnerToPlay do
  use Ecto.Migration

  def change do
    alter table(:plays) do
      add :winner, :string
    end
  end
end
