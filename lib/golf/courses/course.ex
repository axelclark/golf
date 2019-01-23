defmodule Golf.Courses.Course do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  schema "courses" do
    field :name, :string
    field :num_holes, :integer
    has_many :holes, Golf.Courses.Hole

    timestamps()
  end

  def sort_alphabetically(query) do
    from(
      c in query,
      order_by: c.name
    )
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :num_holes])
    |> validate_required([:name, :num_holes])
    |> cast_assoc(:holes)
  end
end
