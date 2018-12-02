defmodule Golf.Courses do
  @moduledoc """
  The Courses context.
  """

  import Ecto.Query, warn: false
  alias Golf.Repo

  alias Golf.Courses.{Course, Hole}

  @doc """
  Returns the list of courses.
  """
  def list_courses do
    Course
    |> preload(:holes)
    |> Repo.all()
  end

  @doc """
  Gets a single course.

  Raises `Ecto.NoResultsError` if the Course does not exist.
  """
  def get_course!(id) do
    Course
    |> preload(:holes)
    |> Repo.get!(id)
  end

  @doc """
  Creates a course.
  """
  def create_course(attrs \\ %{}) do
    %Course{}
    |> Course.changeset(attrs)
    |> Repo.insert()
    |> create_holes_for_course()
  end

  defp create_holes_for_course({:error, _} = error), do: error

  defp create_holes_for_course({:ok, %{num_holes: 0} = course}), do: course

  defp create_holes_for_course({:ok, %{num_holes: num_holes} = course})
       when is_integer(num_holes) and num_holes > 0 do
    Enum.each(1..num_holes, fn hole_number ->
      attrs = %{hole_number: hole_number, course_id: course.id}
      create_hole(attrs)
    end)

    {:ok, course}
  end

  defp create_holes_for_course({:ok, _course} = result), do: result

  @doc """
  Creates a hole.
  """
  def create_hole(attrs \\ %{}) do
    %Hole{}
    |> Hole.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a course.
  """
  def update_course(%Course{} = course, attrs) do
    course
    |> Course.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Course.
  """
  def delete_course(%Course{} = course) do
    Repo.delete(course)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking course changes.
  """
  def change_course(%Course{} = course) do
    Course.changeset(course, %{})
  end

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
