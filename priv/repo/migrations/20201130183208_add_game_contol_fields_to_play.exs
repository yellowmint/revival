defmodule Revival.Repo.Migrations.AddStatusToPlay do
  use Ecto.Migration

  def change do
    alter table(:plays) do
      add :status, :string
      add :started_at, :utc_datetime
      add :finished_at, :utc_datetime
      add :next_move, :string
      add :next_move_deadline, :utc_datetime
    end
  end
end
