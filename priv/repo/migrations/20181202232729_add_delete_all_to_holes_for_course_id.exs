defmodule Golf.Repo.Migrations.AddDeleteAllToHolesForCourseId do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE holes DROP CONSTRAINT holes_course_id_fkey"
    alter table(:holes) do
      modify :course_id, references(:courses, on_delete: :delete_all)
    end
  end
end
