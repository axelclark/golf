defmodule Golf.Scorecard.Round do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rounds" do
    field :started_on, :date, default: Date.utc_today()
    field :total_score, :integer, virtual: true, default: 0
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
    |> foreign_key_constraint(:course_id)
  end

  def add_total_score(round) do
    Enum.reduce(round.scores, round, &calc_total_score/2)
  end

  defp calc_total_score(%{num_strokes: 0}, round), do: round

  defp calc_total_score(score, round) do
    score = score.num_strokes - score.hole.par
    Map.update!(round, :total_score, &(&1 + score))
  end
end
