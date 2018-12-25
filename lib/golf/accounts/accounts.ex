defmodule Golf.Accounts do
  @moduledoc """
  The Accounts context.
  """

  use Pow.Ecto.Context,
    repo: Golf.Repo,
    user: Golf.Accounts.User

  import Ecto.Query, warn: false

  alias Golf.Repo
  alias Pow.Ecto.Schema.Password
  alias Golf.Accounts.User

  def authenticate(email, password) do
    user = Repo.get_by(User, email: email)

    with %{password_hash: digest} <- user,
         true <- Password.pbkdf2_verify(password, digest) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  def calc_avg_strokes(%User{} = %{id: id}) do
    courses =
      %{golfer_id: id}
      |> Golf.Scorecard.list_rounds()
      |> Enum.group_by(&(&1.course_id))
      |> Enum.map(&calc_course_avg/1)

    %{courses: courses}
  end

  defp calc_course_avg({course_id, rounds}) do
    holes =
      rounds
      |> Enum.reduce([], &(&1.scores ++ &2))
      |> Enum.group_by(&(&1.hole_id))
      |> Enum.map(&calc_hole_avg/1)

    %{id: course_id, holes: holes}
  end

  defp calc_hole_avg({hole_id, scores}) do
    count = Enum.count(scores)
    sum =
      scores
      |> Enum.map(&(&1.num_strokes))
      |> Enum.sum()

    %{id: hole_id, avg_strokes: sum / count}
  end

  @doc """
  Creates a user, uses pow function.
  """
  def create_user(params) do
    pow_create(params)
  end

  @doc """
  Gets a single course.

  Raises `Ecto.NoResultsError` if the Course does not exist.
  """
  def get_user!(id) do
    Repo.get!(User, id)
  end
end
