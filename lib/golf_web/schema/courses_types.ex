defmodule GolfWeb.Schema.CoursesTypes do
  use Absinthe.Schema.Notation

  alias GolfWeb.Resolvers

  @desc "A golf gourse"
  object :course do
    field :id, :id
    field :name, :string
    field :num_holes, :integer

    field :holes, list_of(:hole) do
      resolve(&Resolvers.Courses.holes_for_course/3)
    end
  end

  @desc "A hole on a golf gourse"
  object :hole do
    field :id, :id
    field :hole_number, :integer
    field :par, :integer
    field :course_id, :integer
    field :course, :course
  end

  @desc "Inputs for a course"
  input_object :course_input do
    field :name, :string
    field :num_holes, :integer
    field :holes, list_of(:hole_input)
  end

  @desc "Inputs for a hole"
  input_object :hole_input do
    field :id, :id
    field :hole_number, :integer
    field :par, :integer
    field :course_id, :integer
  end
end
