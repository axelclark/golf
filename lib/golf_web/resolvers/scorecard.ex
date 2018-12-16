defmodule GolfWeb.Resolvers.Scorecard do
  import Ecto.Query, warn: false

  alias Golf.Scorecard

  def create_round(_parent, %{input: params}, _resolution) do
    case Scorecard.create_round(params) do
      {:error, changeset} ->
        {
          :error,
          message: "Couldn't create round", details: error_details(changeset)
        }

      {:ok, _} = success ->
        success
    end
  end

  def get_round(_parent, %{id: id}, _resolution) do
    {:ok, Scorecard.get_round!(id)}
  end

  def list_rounds(_parent, _args, _resolution) do
    {:ok, Scorecard.list_rounds()}
  end

  def update_score(_parent, %{id: id, input: params}, _resolution) do
    score = Scorecard.get_score!(id)

    case Scorecard.update_score(score, params) do
      {:error, changeset} ->
        {
          :error,
          message: "Couldn't create score", details: error_details(changeset)
        }

      {:ok, _} = success ->
        success
    end
  end

  def scores_for_round(round, _, _) do
    scores =
      round
      |> Ecto.assoc(:scores)
      |> preload(:hole)
      |> Golf.Repo.all()

    {:ok, scores}
  end

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
