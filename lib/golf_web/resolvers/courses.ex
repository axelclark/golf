defmodule GolfWeb.Resolvers.Courses do
  import GolfWeb.Resolvers.ErrorHelpers
  alias Golf.Courses

  @create_error "Couldn't create course"
  @update_error "Couldn't update course"
  @auth_error "Must provide auth token to get current user"

  def create_course(_parent, %{input: params}, %{context: %{current_user: _user}}) do
    case Courses.create_course(params) do
      {:error, changeset} ->
        error_response(@create_error, changeset)

      {:ok, _} = success ->
        success
    end
  end

  def create_course(_parent, _args, _resolution) do
    error_response(@create_error, @auth_error)
  end

  def list_courses(_parent, _args, _resolution) do
    {:ok, Golf.Courses.list_courses()}
  end

  def holes_for_course(course, _, _) do
    query = Ecto.assoc(course, :holes)
    {:ok, Golf.Repo.all(query)}
  end

  def update_course(_parent, %{id: id, input: params}, %{context: %{current_user: _user}}) do
    course = Courses.get_course!(id)

    case Courses.update_course(course, params) do
      {:error, changeset} ->
        error_response(@update_error, changeset)

      {:ok, _} = success ->
        success
    end
  end

  def update_course(_parent, _args, _resolution) do
    error_response(@update_error, @auth_error)
  end
end
