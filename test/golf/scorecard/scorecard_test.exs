defmodule Golf.ScorecardTest do
  use Golf.DataCase

  alias Golf.Scorecard

  describe "rounds" do
    alias Golf.Scorecard.{Round, Score}

    @valid_attrs %{"started_on" => ~D[2010-04-17]}
    @update_attrs %{"started_on" => ~D[2011-05-18]}
    @invalid_attrs %{"started_on" => nil}

    test "list_rounds/0 returns all rounds" do
      course = insert(:course)
      round = insert(:round, course: course)

      [result] = Scorecard.list_rounds()

      assert result.id == round.id
      assert result.course.name == course.name
    end

    test "get_round!/1 returns the round with given id" do
      round = insert(:round)
      assert Scorecard.get_round!(round.id).id == round.id
    end

    test "get_round!/1 returns the round with total score and holes to go" do
      course = insert(:course)
      hole1 = insert(:hole, course: course, par: 3)
      hole2 = insert(:hole, course: course, par: 4)
      hole3 = insert(:hole, course: course, par: 4)

      round = insert(:round)
      insert(:score, hole: hole1, round: round, num_strokes: 2)
      insert(:score, hole: hole2, round: round, num_strokes: 4)
      insert(:score, hole: hole3, round: round, num_strokes: 0)

      result = Scorecard.get_round!(round.id)

      assert result.total_score == -1
      assert result.holes_to_play == 1
    end

    test "get_round!/1 returns the round with holes to go" do
      course = insert(:course)
      hole1 = insert(:hole, course: course, par: 3)
      hole2 = insert(:hole, course: course, par: 4)
      hole3 = insert(:hole, course: course, par: 4)

      round = insert(:round)
      insert(:score, hole: hole1, round: round, num_strokes: 2)
      insert(:score, hole: hole2, round: round, num_strokes: 0)
      insert(:score, hole: hole3, round: round, num_strokes: 0)

      result = Scorecard.get_round!(round.id)

      assert result.holes_to_play == 2
    end

    test "get_round!/1 returns the round with holes to go as 0 when done" do
      course = insert(:course)
      hole1 = insert(:hole, course: course, par: 3)

      round = insert(:round)
      insert(:score, hole: hole1, round: round, num_strokes: 2)

      result = Scorecard.get_round!(round.id)

      assert result.holes_to_play == 0
    end

    test "create_round/1 with valid data creates a round and scores" do
      golfer = insert(:user)
      course = insert(:course)
      _hole1 = insert(:hole, course: course)
      _hole2 = insert(:hole, course: course)

      attrs =
        @valid_attrs
        |> Map.put("course_id", course.id)
        |> Map.put("golfer_id", golfer.id)

      {:ok, %Round{} = result} = Scorecard.create_round(attrs)
      round = Scorecard.get_round!(result.id)

      assert result.started_on == ~D[2010-04-17]
      assert Enum.count(round.scores) == 2
    end

    test "create_round/1 with no date creates a round" do
      golfer = insert(:user)
      course = insert(:course)

      attrs =
        %{}
        |> Map.put("course_id", course.id)
        |> Map.put("golfer_id", golfer.id)

      assert {:ok, %Round{} = round} = Scorecard.create_round(attrs)
      assert round.started_on == Date.utc_today()
    end

    test "create_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scorecard.create_round(@invalid_attrs)
    end

    test "update_round/2 with valid data updates the round" do
      golfer = insert(:user)
      course = insert(:course)
      hole = insert(:hole, course: course)
      round = insert(:round, course: course, golfer: golfer)
      insert(:score, hole: hole, round: round)

      round = %{scores: [score]} = Scorecard.get_round!(round.id)
      score_attrs = %{"0" => %{"id" => score.id, "num_strokes" => "4"}}
      attrs = Map.put(@update_attrs, "scores", score_attrs)

      {:ok, %Round{}} = Scorecard.update_round(round, attrs)
      result = %{scores: [score]} = Scorecard.get_round!(round.id)

      assert result.started_on == ~D[2011-05-18]
      assert score.num_strokes == 4
    end

    test "update_round/2 with invalid data returns error changeset" do
      round = insert(:round)
      assert {:error, %Ecto.Changeset{}} = Scorecard.update_round(round, @invalid_attrs)
      assert round.id == Scorecard.get_round!(round.id).id
    end

    test "delete_round/1 deletes the round" do
      course = insert(:course)
      hole = insert(:hole, course: course)
      round = insert(:round, course: course)
      score = insert(:score, hole: hole, round: round)

      assert {:ok, %Round{}} = Scorecard.delete_round(round)
      assert_raise Ecto.NoResultsError, fn -> Scorecard.get_round!(round.id) end
      assert_raise Ecto.NoResultsError, fn -> Golf.Repo.get!(Score, score.id) end
    end

    test "change_round/1 returns a round changeset" do
      round = insert(:round)
      assert %Ecto.Changeset{} = Scorecard.change_round(round)
    end
  end

  describe "scores" do
    alias Golf.Scorecard.Score

    test "get_score!/1 returns the score with given id" do
      hole = insert(:hole, par: 3, hole_number: 1)
      score = insert(:score, num_strokes: 0, hole: hole)
      result = Scorecard.get_score!(score.id)

      assert result.id == score.id
      assert result.hole.par == hole.par
    end

    test "create_score/1 with valid data creates a score" do
      course = insert(:course)
      round = insert(:round, course: course)
      hole = insert(:hole, course: course)
      attrs = %{hole_id: hole.id, round_id: round.id}

      {:ok, %Score{} = result} = Scorecard.create_score(attrs)

      assert result.round_id == round.id
      assert result.hole_id == hole.id
      assert result.num_strokes == 0
    end

    test "create_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scorecard.create_score(%{})
    end

    test "increment_score/1 increases score by 1" do
      score = insert(:score, num_strokes: 1)

      {:ok, %Score{} = result} = Scorecard.increment_score(score.id)

      assert result.num_strokes == 2
    end

    test "increment_score/1 increases score by 1 when nil" do
      score = insert(:score, num_strokes: 0)

      {:ok, %Score{} = result} = Scorecard.increment_score(score.id)

      assert result.num_strokes == 1
    end

    test "decrement_score/1 decreases score by 1" do
      score = insert(:score, num_strokes: 3)

      {:ok, %Score{} = result} = Scorecard.decrement_score(score.id)

      assert result.num_strokes == 2
    end

    test "update_score/2 with valid data updates the score" do
      score = insert(:score, num_strokes: 0)
      attrs = %{"num_strokes" => "4"}

      {:ok, result} = Scorecard.update_score(score, attrs)

      assert result.num_strokes == 4
      assert result.id == score.id
    end

    test "update_score/2 with invalid data returns error changeset" do
      score = insert(:score, num_strokes: 0)
      attrs = %{"num_strokes" => "NaN"}

      assert {:error, %Ecto.Changeset{}} = Scorecard.update_score(score, attrs)
    end

    test "update_score/2 returns an error if num_strokes < 0" do
      score = insert(:score, num_strokes: 0)
      attrs = %{"num_strokes" => -1}

      assert {:error, %Ecto.Changeset{}} = Scorecard.update_score(score, attrs)
    end
  end
end
