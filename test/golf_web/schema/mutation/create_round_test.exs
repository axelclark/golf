defmodule GolfWeb.Schema.Mutation.CreateRoundTest do
  use GolfWeb.ConnCase

  @query """
  mutation ($round: RoundInput!) {
    round: createRound(input: $round) {
      courseId
      course {
        name
      }
    }
  }
  """
  test "createRound field creates a round", %{conn: conn} do
    course = insert(:course)

    round = %{
      "courseId" => course.id
    }

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"round" => round}

    assert json_response(conn, 200) == %{
             "data" => %{
               "round" => %{
                 "courseId" => round["courseId"],
                 "course" => %{
                   "name" => course.name
                 }
               }
             }
           }
  end

  test "createRound field errors with an existing name", %{conn: conn} do
    round = %{
      "courseId" => 0
    }

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"round" => round}

    assert json_response(conn, 200) == %{
             "data" => %{"round" => nil},
             "errors" => [
               %{
                 "locations" => [%{"column" => 0, "line" => 2}],
                 "path" => ["round"],
                 "details" => %{"course_id" => ["does not exist"]},
                 "message" => "Couldn't create round"
               }
             ]
           }
  end
end
