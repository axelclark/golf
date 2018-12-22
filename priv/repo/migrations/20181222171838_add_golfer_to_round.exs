defmodule Golf.Repo.Migrations.AddGolferToRound do
  use Ecto.Migration

  def change do
    alter table(:rounds) do
      add :golfer_id, references(:users)
    end
  end
end
