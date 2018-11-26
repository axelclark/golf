defmodule GolfWeb.Schema.Query.CoursesTest do
  use GolfWeb.ConnCase

  setup do
    ExMachina.Sequence.reset()
    courses = insert_list(3, :course)
    {:ok, courses: courses}
  end

  @query """
  {
    courses {
      name
    }
  }
  """
  test "courses field returns courses" do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
             "data" => %{
               "courses" => [
                 %{"name" => "course0"},
                 %{"name" => "course1"},
                 %{"name" => "course2"}
               ]
             }
           }
  end
end
