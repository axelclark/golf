defmodule GolfWeb.Schema.Mutation.UpdateCourseTest do
  use GolfWeb.ConnCase

  @query """
  mutation ($id: ID!, $course: CourseInput!) {
  course: updateCourse(id: $id, input: $course) {
      id
      numHoles
      name
      holes {
        id
        holeNumber
        par
      }
    }
  }
  """
  test "updateCourse field updates a course and its holes", %{conn: conn} do
    golfer = insert(:user)
    authed_conn = auth_user(conn, golfer)
    course = insert(:course, name: "name", num_holes: 2)
    hole1 = insert(:hole, par: 3, hole_number: 1, course: course)
    hole2 = insert(:hole, par: 3, hole_number: 2, course: course)

    course_attrs = %{
      "name" => "new name",
      "holes" => [
        %{"id" => hole1.id, "par" => 4},
        %{"id" => hole2.id, "par" => 3}
      ]
    }

    conn =
      post authed_conn, "/api",
        query: @query,
        variables: %{"id" => course.id, "course" => course_attrs}

    assert json_response(conn, 200) == %{
             "data" => %{
               "course" => %{
                 "id" => Integer.to_string(course.id),
                 "name" => "new name",
                 "numHoles" => 2,
                 "holes" => [
                   %{
                     "par" => 4,
                     "holeNumber" => 1,
                     "id" => Integer.to_string(hole1.id)
                   },
                   %{
                     "par" => 3,
                     "holeNumber" => 2,
                     "id" => Integer.to_string(hole2.id)
                   }
                 ]
               }
             }
           }
  end

  test "updateCourse field returns error", %{conn: conn} do
    golfer = insert(:user)
    authed_conn = auth_user(conn, golfer)
    course = insert(:course, name: "name", num_holes: 2)
    hole1 = insert(:hole, par: 3, hole_number: 1, course: course)
    hole2 = insert(:hole, par: 3, hole_number: 2, course: course)

    course_attrs = %{
      "name" => "new name",
      "holes" => [
        %{"id" => hole1.id, "par" => -1},
        %{"id" => hole2.id, "par" => 3}
      ]
    }

    conn =
      post authed_conn, "/api",
        query: @query,
        variables: %{"id" => course.id, "course" => course_attrs}

    assert json_response(conn, 200) == %{
             "data" => %{"course" => nil},
             "errors" => [
               %{
                 "details" => %{
                   "holes" => [
                     %{"par" => ["must be greater than or equal to 1"]},
                     %{}
                   ]
                 },
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "message" => "Couldn't update course",
                 "path" => ["course"]
               }
             ]
           }
  end

  test "updateCourse field errors when header not provided", %{conn: conn} do
    course = insert(:course, name: "name", num_holes: 2)
    hole1 = insert(:hole, par: 3, hole_number: 1, course: course)
    hole2 = insert(:hole, par: 3, hole_number: 2, course: course)

    course_attrs = %{
      "name" => "new name",
      "holes" => [
        %{"id" => hole1.id, "par" => 4},
        %{"id" => hole2.id, "par" => 3}
      ]
    }

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"id" => course.id, "course" => course_attrs}

    assert json_response(conn, 200) == %{
             "data" => %{"course" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "path" => ["course"],
                 "details" => "Must provide auth token to get current user",
                 "message" => "Couldn't update course"
               }
             ]
           }
  end
end
