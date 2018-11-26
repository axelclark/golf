defmodule GolfWeb.Resolvers.Courses do
  def list_courses(_parent, _args, _resolution) do
    {:ok, Golf.Courses.list_courses()}
  end
end
