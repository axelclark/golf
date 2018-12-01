defmodule Golf.Scorecard.Round do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rounds" do
    field :started_on, :date
    belongs_to :course, Golf.Courses.Course
    has_many :scores, Golf.Scorecard.Score

    timestamps()
  end

  @doc false
  def changeset(round, attrs) do
    round
    |> cast(attrs, [:started_on, :course_id])
    |> validate_required([:started_on, :course_id])
    |> cast_assoc(:scores)
  end
end
