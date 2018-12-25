defmodule Golf.AccountsTest do
  use Golf.DataCase

  alias Golf.Accounts

  describe "users" do
    alias Golf.Accounts.{User}

    test "calculate_avg_strokes/1 returns courses with average strokes" do
      course = insert(:course)
      hole = insert(:hole, course: course, par: 3)
      golfer = insert(:user)
      round = insert(:round, course: course, golfer: golfer)
      _score = insert(:score, round: round, hole: hole, num_strokes: 4)
      round2 = insert(:round, course: course, golfer: golfer)
      _score2 = insert(:score, round: round2, hole: hole, num_strokes: 3)

      %{courses: [course_result]} = Accounts.calc_avg_strokes(golfer)
      %{holes: [hole_result]} = course_result

      assert course_result.id == course.id
      assert hole_result.avg_strokes == 3.5
      assert hole_result.id == hole.id
    end
  end
end
