defmodule Golf.Scorecard.Round do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rounds" do
    field :started_on, :date
    belongs_to :course, Golf.Courses.Course

    timestamps()
  end

  @doc false
  def changeset(round, attrs) do
    round
    |> cast(attrs, [:started_on, :course_id])
    |> validate_required([:started_on, :course_id])
  end
end
