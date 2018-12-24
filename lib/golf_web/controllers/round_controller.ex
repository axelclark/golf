defmodule GolfWeb.RoundController do
  use GolfWeb, :controller

  alias Golf.{Courses, Scorecard}

  def index(conn, _params) do
    rounds = Scorecard.list_rounds()
    render(conn, "index.html", rounds: rounds)
  end

  def create(conn, %{"round" => round_params}) do
    current_user = conn.assigns[:current_user]
    round_params = Map.put(round_params, "golfer_id", current_user.id)

    case Scorecard.create_round(round_params) do
      {:ok, round} ->
        conn
        |> put_flash(:info, "Round created successfully.")
        |> redirect(to: Routes.round_path(conn, :show, round))

      {:error, %Ecto.Changeset{} = _changeset} ->
        conn
        |> put_flash(:error, "Error when creating round.")
        |> redirect(to: Routes.course_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    round = Scorecard.get_round!(id)
    render(conn, "show.html", round: round)
  end

  def edit(conn, %{"id" => id}) do
    round = Scorecard.get_round!(id)
    changeset = Scorecard.change_round(round)
    courses = Courses.list_courses()
    render(conn, "edit.html", round: round, changeset: changeset, courses: courses)
  end

  def update(conn, %{"id" => id, "round" => round_params}) do
    round = Scorecard.get_round!(id)

    case Scorecard.update_round(round, round_params) do
      {:ok, round} ->
        conn
        |> put_flash(:info, "Round updated successfully.")
        |> redirect(to: Routes.round_path(conn, :show, round))

      {:error, %Ecto.Changeset{} = changeset} ->
        courses = Courses.list_courses()
        render(conn, "edit.html", round: round, changeset: changeset, courses: courses)
    end
  end

  def delete(conn, %{"id" => id}) do
    round = Scorecard.get_round!(id)
    {:ok, _round} = Scorecard.delete_round(round)

    conn
    |> put_flash(:info, "Round deleted successfully.")
    |> redirect(to: Routes.round_path(conn, :index))
  end
end
