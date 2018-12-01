defmodule Golf.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :num_strokes, :integer
      add :hole_id, references(:holes, on_delete: :nothing)
      add :round_id, references(:rounds, on_delete: :nothing)

      timestamps()
    end

    create index(:scores, [:hole_id])
    create index(:scores, [:round_id])
  end
end
