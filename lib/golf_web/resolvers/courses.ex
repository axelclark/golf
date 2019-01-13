defmodule GolfWeb.Resolvers.Courses do
  alias Golf.Courses

  def create_course(_parent, %{input: params}, %{context: %{current_user: _user}}) do
    case Courses.create_course(params) do
      {:error, changeset} ->
        {
          :error,
          message: "Couldn't create course", details: error_details(changeset)
        }

      {:ok, _} = success ->
        success
    end
  end

  def create_course(_parent, _args, _resolution) do
    {
      :error,
      message: "Couldn't create course", details: "Must provide auth token to get current user"
    }
  end

  def list_courses(_parent, _args, _resolution) do
    {:ok, Golf.Courses.list_courses()}
  end

  def holes_for_course(course, _, _) do
    query = Ecto.assoc(course, :holes)
    {:ok, Golf.Repo.all(query)}
  end

  ## Helpers

  ## create_course

  defp error_details(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
