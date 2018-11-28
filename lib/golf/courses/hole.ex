defmodule Golf.Courses.Hole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "holes" do
    field :hole_number, :integer
    field :par, :integer
    belongs_to(:course, Golf.Courses.Course)

    timestamps()
  end

  @doc false
  def changeset(hole, attrs) do
    hole
    |> cast(attrs, [:hole_number, :par])
    |> validate_required([:hole_number, :par])
  end
end
