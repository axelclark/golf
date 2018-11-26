defmodule GolfWeb.CourseController do
  use GolfWeb, :controller

  alias Golf.Courses
  alias Golf.Courses.Course

  use Absinthe.Phoenix.Controller,
    schema: GolfWeb.Schema

  @graphql """
  query Index @action(mode: INTERNAL) {
    courses
  }
  """
  def index(conn, result) do
    render(conn, "index.html", courses: result.data.courses)
  end

  def new(conn, _params) do
    changeset = Courses.change_course(%Course{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"course" => course_params}) do
    case Courses.create_course(course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course created successfully.")
        |> redirect(to: Routes.course_path(conn, :show, course))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course = Courses.get_course!(id)
    render(conn, "show.html", course: course)
  end

  def edit(conn, %{"id" => id}) do
    course = Courses.get_course!(id)
    changeset = Courses.change_course(course)
    render(conn, "edit.html", course: course, changeset: changeset)
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    course = Courses.get_course!(id)

    case Courses.update_course(course, course_params) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course updated successfully.")
        |> redirect(to: Routes.course_path(conn, :show, course))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", course: course, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course = Courses.get_course!(id)
    {:ok, _course} = Courses.delete_course(course)

    conn
    |> put_flash(:info, "Course deleted successfully.")
    |> redirect(to: Routes.course_path(conn, :index))
  end
end
