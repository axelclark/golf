defmodule Golf.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :started_on, :date
      add :course_id, references(:courses, on_delete: :nothing)

      timestamps()
    end

    create index(:rounds, [:course_id])
  end
end
