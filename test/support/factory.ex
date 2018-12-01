defmodule Golf.Factory do
  use ExMachina.Ecto, repo: Golf.Repo

  alias Golf.{Courses, Scorecard}

  def course_factory do
    %Courses.Course{
      name: sequence("course"),
      num_holes: sequence(:num_holes, [18, 9])
    }
  end

  def hole_factory do
    %Courses.Hole{
      hole_number: sequence(:hole_number, Enum.to_list(1..18)),
      par: sequence(:par, [3, 4]),
      course: build(:course)
    }
  end

  def round_factory do
    %Scorecard.Round{
      started_on: ~D[2018-11-30],
      course: build(:course)
    }
  end

  def score_factory do
    %Scorecard.Score{
      num_strokes: nil,
      round: build(:round),
      hole: build(:hole)
    }
  end
end
