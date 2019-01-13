defmodule GolfWeb.Schema.Mutation.CreateCourseTest do
  use GolfWeb.ConnCase

  @query """
  mutation ($course: CourseInput!) {
    course: createCourse(input: $course) {
      name
      num_holes
      holes {
        par
        hole_number
      }
    }
  }
  """
  test "createCourse field creates a course", %{conn: conn} do
    golfer = insert(:user)

    course_attrs = %{
      "name" => "Mercer County",
      "num_holes" => 3
    }

    authed_conn = auth_user(conn, golfer)

    conn =
      post authed_conn, "/api",
        query: @query,
        variables: %{"course" => course_attrs}

    assert json_response(conn, 200) == %{
             "data" => %{
               "course" => %{
                 "name" => course_attrs["name"],
                 "num_holes" => 3,
                 "holes" => [
                   %{"hole_number" => 1, "par" => 3},
                   %{"hole_number" => 2, "par" => 3},
                   %{"hole_number" => 3, "par" => 3}
                 ]
               }
             }
           }
  end

  test "createCourse field errors with invalid params", %{conn: conn} do
    golfer = insert(:user)

    course_attrs = %{
      "name" => nil,
      "num_holes" => 3
    }

    authed_conn = auth_user(conn, golfer)

    conn =
      post authed_conn, "/api",
        query: @query,
        variables: %{"course" => course_attrs}

    assert json_response(conn, 200) == %{
             "data" => %{"course" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "path" => ["course"],
                 "details" => %{"name" => ["can't be blank"]},
                 "message" => "Couldn't create course"
               }
             ]
           }
  end

  test "createCourse field errors when header not provided", %{conn: conn} do
    course_attrs = %{
      "name" => "Mercer County",
      "num_holes" => 3
    }

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"course" => course_attrs}

    assert json_response(conn, 200) == %{
             "data" => %{"course" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "path" => ["course"],
                 "details" => "Must provide auth token to get current user",
                 "message" => "Couldn't create course"
               }
             ]
           }
  end
end
