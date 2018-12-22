defmodule Golf.Factory do
  use ExMachina.Ecto, repo: Golf.Repo

  alias Golf.{Accounts, Courses, Scorecard}

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
      course: build(:course),
      golfer: build(:user)
    }
  end

  def score_factory do
    %Scorecard.Score{
      num_strokes: 0,
      round: build(:round),
      hole: build(:hole)
    }
  end

  def user_factory do
    %Accounts.User{
      email: sequence(:email, &"user-#{&1}@foo.com"),
      password_hash: "password_hash"
    }
  end

  def insert_user(attrs \\ %{}) do
    changes =
      Map.merge(
        %{
          email: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}@example.com",
          password: "secret_password",
          confirm_password: "secret_password"
        },
        attrs
      )

    %Accounts.User{}
    |> Accounts.User.changeset(changes)
    |> Golf.Repo.insert!()
  end
end
