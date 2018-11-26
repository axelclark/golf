defmodule Golf.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :num_holes, :integer

      timestamps()
    end
  end
end
