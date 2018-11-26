defmodule Golf.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset

  schema "courses" do
    field :name, :string
    field :num_holes, :integer

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :num_holes])
    |> validate_required([:name, :num_holes])
  end
end
