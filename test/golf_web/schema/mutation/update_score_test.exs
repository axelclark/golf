defmodule GolfWeb.Schema.Mutation.UpdateScoreTest do
  use GolfWeb.ConnCase

  @query """
  mutation ($id: ID!, $score: ScoreInput!) {
  score: updateScore(id: $id, input: $score) {
      id
      numStrokes
      hole {
        holeNumber
        par
      }
      round {
        totalScore
      }
    }
  }
  """
  test "updateScore field creates a score", %{conn: conn} do
    hole = insert(:hole, par: 3, hole_number: 1)
    score = insert(:score, num_strokes: 0, hole: hole)

    score_attrs = %{
      "numStrokes" => 4
    }

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"id" => score.id, "score" => score_attrs}

    assert json_response(conn, 200) == %{
             "data" => %{
               "score" => %{
                 "id" => Integer.to_string(score.id),
                 "numStrokes" => 4,
                 "hole" => %{
                   "par" => 3,
                   "holeNumber" => 1
                 },
                 "round" => %{
                   "totalScore" => 1
                 }
               }
             }
           }
  end

  test "updateScore field errors with a string for numStrokes", %{conn: conn} do
    score = insert(:score, num_strokes: 0)

    score_attrs = %{
      "numStrokes" => "NaN"
    }

    conn =
      post conn, "/api",
        query: @query,
        variables: %{"id" => score.id, "score" => score_attrs}

    assert json_response(conn, 200) == %{
             "errors" => [
               %{
                 "locations" => [],
                 "message" =>
                   "Argument \"input\" has invalid value $score.\nIn field \"numStrokes\": Expected type \"Int!\", found \"NaN\"."
               }
             ]
           }
  end
end
