defmodule GolfWeb.Schema.Query.ScorecardTest do
  use GolfWeb.ConnCase

  require Ecto.Query

  setup do
    ExMachina.Sequence.reset()
    course = insert(:course)
    holes = insert_list(3, :hole, course: course)
    round = insert(:round, course: course)
    scores = Enum.map(holes, &insert(:score, round: round, hole: &1))

    {:ok, course: course, holes: holes, round: round, scores: scores}
  end

  @query """
  {
    rounds {
      course {
        name
        holes {
          holeNumber
          par
        }
      },
      startedOn
      scores {
        numStrokes
        hole {
          holeNumber
          par
        }
      }
    }
  }
  """
  test "rounds field returns rounds", %{round: round} do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
             "data" => %{
               "rounds" => [
                 %{
                   "startedOn" => Date.to_iso8601(round.started_on),
                   "course" => %{
                     "name" => "course0",
                     "holes" => [
                       %{"holeNumber" => 1, "par" => 3},
                       %{"holeNumber" => 2, "par" => 4},
                       %{"holeNumber" => 3, "par" => 3}
                     ]
                   },
                   "scores" => [
                     %{"numStrokes" => 0, "hole" => %{"holeNumber" => 1, "par" => 3}},
                     %{"numStrokes" => 0, "hole" => %{"holeNumber" => 2, "par" => 4}},
                     %{"numStrokes" => 0, "hole" => %{"holeNumber" => 3, "par" => 3}}
                   ]
                 }
               ]
             }
           }
  end

  @query """
  query ($id: ID!) {
    round(id: $id) {
      course {
        name
        holes {
          holeNumber
          par
        }
      },
      startedOn
      scores {
        numStrokes
        hole {
          holeNumber
          par
        }
      }
    }
  }
  """
  test "round field returns a round", %{round: round} do
    conn = build_conn()
    conn = get conn, "/api", query: @query, variables: %{id: round.id}

    assert json_response(conn, 200) == %{
             "data" => %{
               "round" => %{
                 "startedOn" => Date.to_iso8601(round.started_on),
                 "course" => %{
                   "name" => "course0",
                   "holes" => [
                     %{"holeNumber" => 1, "par" => 3},
                     %{"holeNumber" => 2, "par" => 4},
                     %{"holeNumber" => 3, "par" => 3}
                   ]
                 },
                 "scores" => [
                   %{"numStrokes" => 0, "hole" => %{"holeNumber" => 1, "par" => 3}},
                   %{"numStrokes" => 0, "hole" => %{"holeNumber" => 2, "par" => 4}},
                   %{"numStrokes" => 0, "hole" => %{"holeNumber" => 3, "par" => 3}}
                 ]
               }
             }
           }
  end
end
