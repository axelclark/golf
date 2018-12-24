defmodule GolfWeb.RoundControllerTest do
  use GolfWeb.ConnCase

  alias Golf.Scorecard

  @create_attrs %{started_on: ~D[2010-04-17]}
  @update_attrs %{started_on: ~D[2011-05-18]}
  @invalid_attrs %{started_on: nil}

  setup %{conn: conn} do
    user = %Golf.Accounts.User{email: "test@example.com", id: 1}
    authed_conn = Pow.Plug.assign_current_user(conn, user, [])
    {:ok, authed_conn: authed_conn, user: user}
  end

  def fixture(:round) do
    {:ok, round} = Scorecard.create_round(@create_attrs)
    round
  end

  describe "index" do
    test "lists all rounds", %{authed_conn: authed_conn} do
      course = insert(:course)
      insert(:round, course: course)

      conn = get(authed_conn, Routes.round_path(authed_conn, :index))

      assert html_response(conn, 200) =~ "Listing Rounds"
      assert String.contains?(conn.resp_body, course.name)
    end
  end

  describe "create round" do
    test "creates round with valid attrs and redirects to show", %{conn: conn} do
      course = insert(:course)
      golfer = insert(:user)
      authed_conn = Pow.Plug.assign_current_user(conn, golfer, [])

      params = %{
        course_id: course.id
      }

      conn = post(authed_conn, Routes.round_path(authed_conn, :create), round: params)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.round_path(conn, :show, id)

      round = Golf.Repo.get!(Scorecard.Round, id)
      assert round.course_id == course.id
      assert round.golfer_id == golfer.id
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.round_path(authed_conn, :create), round: @invalid_attrs)
      assert get_flash(conn, :error) == "Error when creating round."
      assert redirected_to(conn) == Routes.course_path(conn, :index)
    end
  end

  describe "show round" do
    setup [:create_round]

    test "shows a round with scores", %{authed_conn: authed_conn, round: round} do
      hole = insert(:hole, course: round.course)
      score = insert(:score, round: round, hole: hole, num_strokes: 5)

      conn = get(authed_conn, Routes.round_path(authed_conn, :show, round.id))

      assert html_response(conn, 200) =~ "Date"
      assert String.contains?(conn.resp_body, round.course.name)
      assert String.contains?(conn.resp_body, Integer.to_string(score.num_strokes))
    end
  end

  describe "edit round" do
    setup [:create_round]

    test "renders form for editing chosen round", %{authed_conn: authed_conn, round: round} do
      hole = insert(:hole, course: round.course)
      insert(:score, round: round, hole: hole, num_strokes: 3)

      conn = get(authed_conn, Routes.round_path(authed_conn, :edit, round))

      assert html_response(conn, 200) =~ "Edit Round"
      assert String.contains?(conn.resp_body, "Strokes")
    end
  end

  describe "update round" do
    setup [:create_round]

    test "redirects when data is valid", %{authed_conn: authed_conn, round: round} do
      conn =
        put(authed_conn, Routes.round_path(authed_conn, :update, round), round: @update_attrs)

      assert redirected_to(conn) == Routes.round_path(conn, :show, round)

      conn = get(authed_conn, Routes.round_path(authed_conn, :show, round))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, round: round} do
      conn =
        put(authed_conn, Routes.round_path(authed_conn, :update, round), round: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Round"
    end
  end

  describe "delete round" do
    setup [:create_round]

    test "deletes chosen round", %{authed_conn: authed_conn, round: round} do
      conn = delete(authed_conn, Routes.round_path(authed_conn, :delete, round))
      assert redirected_to(conn) == Routes.round_path(conn, :index)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.round_path(authed_conn, :show, round))
      end
    end
  end

  defp create_round(_) do
    round = insert(:round)
    {:ok, round: round}
  end
end
