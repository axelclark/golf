defmodule GolfWeb.Resolvers.Scorecard do
  import Ecto.Query, warn: false
  import GolfWeb.Resolvers.ErrorHelpers

  alias Golf.Scorecard

  @create_round_error "Couldn't create round"
  @update_score_error "Couldn't update course"
  @auth_error "Must provide auth token to get current user"

  def create_round(_parent, %{input: params}, %{context: %{current_user: user}}) do
    golfer_id = Map.get(user, :id)
    params = Map.put(params, :golfer_id, golfer_id)

    case Scorecard.create_round(params) do
      {:error, changeset} ->
        error_response(@create_round_error, changeset)

      {:ok, _} = success ->
        success
    end
  end

  def create_round(_parent, _args, _resolution) do
    error_response(@create_round_error, @auth_error)
  end

  def delete_round(_parent, %{id: id}, _) do
    id
    |> Scorecard.get_round!()
    |> Scorecard.delete_round()
  end

  def get_round(_parent, %{id: id}, _resolution) do
    {:ok, Scorecard.get_round!(id)}
  end

  def list_rounds(_parent, _args, %{context: %{current_user: user}}) do
    {:ok, Scorecard.list_rounds(%{golfer_id: user.id})}
  end

  def list_rounds(_parent, _args, _resolution) do
    {:ok, []}
  end

  def update_score(_parent, %{id: id, input: params}, _resolution) do
    score = Scorecard.get_score!(id)

    case Scorecard.update_score(score, params) do
      {:error, changeset} ->
        error_response(@update_score_error, changeset)

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
end
