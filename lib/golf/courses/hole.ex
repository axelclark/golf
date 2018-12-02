defmodule Golf.Courses.Hole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "holes" do
    field :hole_number, :integer
    field :par, :integer, default: 3
    belongs_to(:course, Golf.Courses.Course)

    timestamps()
  end

  @doc false
  def changeset(hole, attrs) do
    hole
    |> cast(attrs, [:hole_number, :par, :course_id])
    |> validate_required([:hole_number, :par, :course_id])
  end
end
