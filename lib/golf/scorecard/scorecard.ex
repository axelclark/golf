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

  ## Examples

      iex> list_rounds()
      [%Round{}, ...]

  """
  def list_rounds do
    Repo.all(Round)
  end

  @doc """
  Gets a single round.

  Raises `Ecto.NoResultsError` if the Round does not exist.

  ## Examples

      iex> get_round!(123)
      %Round{}

      iex> get_round!(456)
      ** (Ecto.NoResultsError)

  """
  def get_round!(id) do
    Round
    |> preload([:course, [scores: :hole]])
    |> Repo.get!(id)
  end

  @doc """
  Creates a round.

  ## Examples

      iex> create_round(%{field: value})
      {:ok, %Round{}}

      iex> create_round(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

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
      Repo.insert(%Score{hole_id: hole_id, round_id: round.id})
    end)

    {:ok, round}
  end

  defp add_scores_from_holes(attrs), do: attrs

  @doc """
  Updates a round.

  ## Examples

      iex> update_round(round, %{field: new_value})
      {:ok, %Round{}}

      iex> update_round(round, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_round(%Round{} = round, attrs) do
    round
    |> Round.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Round.

  ## Examples

      iex> delete_round(round)
      {:ok, %Round{}}

      iex> delete_round(round)
      {:error, %Ecto.Changeset{}}

  """
  def delete_round(%Round{} = round) do
    Repo.delete(round)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking round changes.

  ## Examples

      iex> change_round(round)
      %Ecto.Changeset{source: %Round{}}

  """
  def change_round(%Round{} = round) do
    Round.changeset(round, %{})
  end
end
