defmodule GolfWeb.Schema.CoursesTypes do
  use Absinthe.Schema.Notation

  @desc "A golf gourse"
  object :course do
    field :id, :id
    field :name, :string
    field :num_holes, :integer
  end
end
