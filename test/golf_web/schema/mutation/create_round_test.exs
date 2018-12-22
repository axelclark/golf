defmodule GolfWeb.Schema.Mutation.CreateRoundTest do
  use GolfWeb.ConnCase

  @query """
  mutation ($round: RoundInput!) {
    round: createRound(input: $round) {
      courseId
      golferId
      course {
        name
      }
    }
  }
  """
  test "createRound field creates a round", %{conn: conn} do
    course = insert(:course)
    golfer = insert(:user)

    round = %{
      "courseId" => course.id
    }

    authed_conn = auth_user(conn, golfer)

    conn =
      post authed_conn, "/api",
        query: @query,
        variables: %{"round" => round}

    assert json_response(conn, 200) == %{
             "data" => %{
               "round" => %{
                 "courseId" => course.id,
                 "golferId" => golfer.id,
                 "course" => %{
                   "name" => course.name
                 }
               }
             }
           }
  end

  test "createRound field errors when course doesn't exist", %{conn: conn} do
    golfer = insert(:user)
    authed_conn = auth_user(conn, golfer)

    round = %{
      "courseId" => 0
    }

    conn =
      post authed_conn, "/api",
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

  test "createRound field errors when header not provided", %{conn: conn} do
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
                 "details" => "Must provide auth token to get current user",
                 "message" => "Couldn't create round"
               }
             ]
           }
  end

  defp auth_user(conn, user) do
    token = GolfWeb.Authentication.sign(%{id: user.id})
    put_req_header(conn, "authorization", "Bearer #{token}")
  end
end
