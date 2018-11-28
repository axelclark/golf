defmodule GolfWeb.Schema.Query.CoursesTest do
  use GolfWeb.ConnCase

  require Ecto.Query

  setup do
    ExMachina.Sequence.reset()
    courses = insert_list(3, :course)
    holes = insert_list(3, :hole, course: hd(courses))
    {:ok, courses: courses, holes: holes}
  end

  @query """
  {
    courses {
      name
      holes {
        hole_number
      }
    }
  }
  """
  test "courses field returns courses" do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
             "data" => %{
               "courses" => [
                 %{
                   "name" => "course0",
                   "holes" => [
                     %{"hole_number" => 1},
                     %{"hole_number" => 2},
                     %{"hole_number" => 3}
                   ]
                 },
                 %{"name" => "course1", "holes" => []},
                 %{"name" => "course2", "holes" => []}
               ]
             }
           }
  end
end
