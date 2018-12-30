defmodule GolfWeb.Schema.Mutation.DeleteRoundTest do
  use GolfWeb.ConnCase

  alias Golf.Scorecard

  @query """
  mutation ($id: ID!) {
  round: deleteRound(id: $id) {
      id
    }
  }
  """
  test "deleteRound deletes a round", %{conn: conn} do
    golfer = insert(:user)
    round = insert(:round, golfer: golfer)

    authed_conn = auth_user(conn, golfer)

    conn =
      post authed_conn, "/api",
        query: @query,
        variables: %{"id" => round.id}

    assert json_response(conn, 200) == %{
             "data" => %{
               "round" => %{
                 "id" => Integer.to_string(round.id)
               }
             }
    }
    assert_raise Ecto.NoResultsError, fn -> Scorecard.get_round!(round.id) end
  end
end
