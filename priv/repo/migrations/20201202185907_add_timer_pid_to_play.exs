defmodule Revival.Repo.Migrations.AddTimerPidToPlay do
  use Ecto.Migration

  def change do
    alter table(:plays) do
      add :timer_pid, :string
    end
  end
end
