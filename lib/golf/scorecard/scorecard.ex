defmodule Golf.Scorecard do
  @moduledoc """
  The Scorecard context.
  """

  import Ecto.Query, warn: false
  alias Golf.Repo

  alias Golf.Scorecard.{Round, Score}
  alias Golf.Courses

  @doc """
  Returns the list of rounds.
  """
  def list_rounds do
    Round
    |> preload([:course, [scores: :hole]])
    |> Repo.all()
  end

  @doc """
  Gets a single round.

  Raises `Ecto.NoResultsError` if the Round does not exist.
  """
  def get_round!(id) do
    Round
    |> preload([:course, [scores: :hole]])
    |> Repo.get!(id)
  end

  @doc """
  Creates a round.
  """
  def create_round(attrs \\ %{}) do
    attrs = Map.put_new(attrs, "started_on", Date.utc_today())

    %Round{}
    |> Round.changeset(attrs)
    |> Repo.insert()
    |> add_scores_from_holes()
  end

  defp add_scores_from_holes({:error, _} = error), do: error

  defp add_scores_from_holes({:ok, round}) do
    %{course_id: course_id} = round
    course = Courses.get_course!(course_id)

    Enum.each(course.holes, fn %{id: hole_id} ->
      score_attrs = %{hole_id: hole_id, round_id: round.id}
      create_score(score_attrs)
    end)

    {:ok, round}
  end

  @doc """
  Creates a score.
  """
  def create_score(attrs \\ %{}) do
    %Score{}
    |> Score.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a round.
  """
  def update_round(%Round{} = round, attrs) do
    round
    |> Round.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Round.
  """
  def delete_round(%Round{} = round) do
    Repo.delete(round)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking round changes.
  """
  def change_round(%Round{} = round) do
    Round.changeset(round, %{})
  end
end
