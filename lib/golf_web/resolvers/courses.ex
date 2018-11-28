defmodule GolfWeb.Resolvers.Courses do
  def list_courses(_parent, _args, _resolution) do
    {:ok, Golf.Courses.list_courses()}
  end

  def holes_for_course(course, _, _) do
    query = Ecto.assoc(course, :holes)
    {:ok, Golf.Repo.all(query)}
  end
end
