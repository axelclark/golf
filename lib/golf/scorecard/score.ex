defmodule Golf.Scorecard.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field :num_strokes, :integer, default: 0
    belongs_to(:hole, Golf.Courses.Hole)
    belongs_to(:round, Golf.Scorecard.Round)

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:num_strokes, :hole_id, :round_id])
    |> validate_required([:hole_id, :round_id])
    |> validate_number(:num_strokes, greater_than_or_equal_to: 0)
  end
end
