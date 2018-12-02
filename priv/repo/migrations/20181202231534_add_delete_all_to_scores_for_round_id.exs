defmodule Golf.Repo.Migrations.AddDeleteAllToScoresForRoundId do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE scores DROP CONSTRAINT scores_round_id_fkey"
    alter table(:scores) do
      modify :round_id, references(:rounds, on_delete: :delete_all)
    end
  end
end
