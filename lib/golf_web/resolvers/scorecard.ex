defmodule GolfWeb.Resolvers.Scorecard do
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

  def error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
