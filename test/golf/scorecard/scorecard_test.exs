defmodule Golf.ScorecardTest do
  use Golf.DataCase

  alias Golf.Scorecard

  describe "rounds" do
    alias Golf.Scorecard.Round

    @valid_attrs %{"started_on" => ~D[2010-04-17]}
    @update_attrs %{"started_on" => ~D[2011-05-18]}
    @invalid_attrs %{"started_on" => nil}

    test "list_rounds/0 returns all rounds" do
      round = insert(:round)
      [result] = Scorecard.list_rounds()
      assert result.id == round.id
    end

    test "get_round!/1 returns the round with given id" do
      round = insert(:round)
      assert Scorecard.get_round!(round.id).id == round.id
    end

    test "create_round/1 with valid data creates a round and scores" do
      course = insert(:course)
      _hole1 = insert(:hole, course: course)
      _hole2 = insert(:hole, course: course)
      attrs = Map.put(@valid_attrs, "course_id", course.id)

      {:ok, %Round{} = result} = Scorecard.create_round(attrs)
      round = Scorecard.get_round!(result.id)

      assert result.started_on == ~D[2010-04-17]
      assert Enum.count(round.scores) == 2
    end

    test "create_round/1 with no date creates a round" do
      course = insert(:course)
      attrs = Map.put(%{}, "course_id", course.id)
      assert {:ok, %Round{} = round} = Scorecard.create_round(attrs)
      assert round.started_on == Date.utc_today()
    end

    test "create_round/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scorecard.create_round(@invalid_attrs)
    end

    test "update_round/2 with valid data updates the round" do
      course = insert(:course)
      hole = insert(:hole, course: course)
      round = insert(:round)
      score = insert(:score, hole: hole, round: round, num_strokes: nil)

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
      round = insert(:round)
      assert {:ok, %Round{}} = Scorecard.delete_round(round)
      assert_raise Ecto.NoResultsError, fn -> Scorecard.get_round!(round.id) end
    end

    test "change_round/1 returns a round changeset" do
      round = insert(:round)
      assert %Ecto.Changeset{} = Scorecard.change_round(round)
    end
  end
end
