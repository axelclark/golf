defmodule GolfWeb.Schema do
  use Absinthe.Schema
  import_types(__MODULE__.CoursesTypes)
  import_types(Absinthe.Phoenix.Types)

  alias GolfWeb.Resolvers

  @desc "The list of golf courses"
  query do
    field :courses, list_of(:course) do
      resolve(&Resolvers.Courses.list_courses/3)
    end
  end
end
