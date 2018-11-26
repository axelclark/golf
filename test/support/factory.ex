defmodule Golf.Factory do
  use ExMachina.Ecto, repo: Golf.Repo

  alias Golf.Courses

  def course_factory do
    %Courses.Course{
      name: sequence("course"),
      num_holes: sequence(:num_holes, [18, 9])
    }
  end
end
