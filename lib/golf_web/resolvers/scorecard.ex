defmodule GolfWeb.Resolvers.Scorecard do
  import Ecto.Query, warn: false

  def create_round(_parent, %{input: params}, _resolution) do
    case Golf.Scorecard.create_round(params) do
      {:error, changeset} ->
        {
          :error,
          message: "Couldn't create course", details: error_details(changeset)
        }

      {:ok, _} = success ->
        success
    end
  end

  def get_round(_parent, %{id: id}, _resolution) do
    {:ok, Golf.Scorecard.get_round!(id)}
  end

  def list_rounds(_parent, _args, _resolution) do
    {:ok, Golf.Scorecard.list_rounds()}
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
