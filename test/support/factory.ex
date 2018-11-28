defmodule Golf.Factory do
  use ExMachina.Ecto, repo: Golf.Repo

  alias Golf.Courses

  def course_factory do
    %Courses.Course{
      name: sequence("course"),
      num_holes: sequence(:num_holes, [18, 9])
    }
  end

  def hole_factory do
    %Courses.Hole{
      hole_number: sequence(:hole_number, Enum.to_list(1..18)),
      par: sequence(:par, [3, 4])
    }
  end
end
