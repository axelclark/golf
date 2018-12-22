defmodule GolfWeb.CourseControllerTest do
  use GolfWeb.ConnCase

  @create_attrs %{name: "some name", num_holes: 42}
  @update_attrs %{name: "some updated name", num_holes: 43}
  @invalid_attrs %{name: nil, num_holes: nil}

  setup %{conn: conn} do
    user = %Golf.Accounts.User{email: "test@example.com", id: 1}
    authed_conn = Pow.Plug.assign_current_user(conn, user, [])
    {:ok, authed_conn: authed_conn, user: user}
  end

  describe "index" do
    setup [:create_course]

    test "lists all courses", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.course_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "Listing Courses"
    end
  end

  describe "new course" do
    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.course_path(authed_conn, :new))
      assert html_response(conn, 200) =~ "New Course"
    end
  end

  describe "create course" do
    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.course_path(authed_conn, :create), course: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.course_path(conn, :show, id)

      conn = get(authed_conn, Routes.course_path(authed_conn, :show, id))
      assert html_response(conn, 200) =~ "Show Course"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.course_path(authed_conn, :create), course: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Course"
    end
  end

  describe "edit course" do
    setup [:create_course]

    test "renders form for editing chosen course", %{authed_conn: authed_conn, course: course} do
      conn = get(authed_conn, Routes.course_path(authed_conn, :edit, course))
      assert html_response(conn, 200) =~ "Edit Course"
    end
  end

  describe "update course" do
    setup [:create_course]

    test "redirects when data is valid", %{authed_conn: authed_conn, course: course} do
      conn =
        put(authed_conn, Routes.course_path(authed_conn, :update, course), course: @update_attrs)

      assert redirected_to(conn) == Routes.course_path(conn, :show, course)

      conn = get(authed_conn, Routes.course_path(authed_conn, :show, course))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, course: course} do
      conn =
        put(authed_conn, Routes.course_path(authed_conn, :update, course), course: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Course"
    end
  end

  describe "delete course" do
    setup [:create_course]

    test "deletes chosen course", %{authed_conn: authed_conn, course: course} do
      conn = delete(authed_conn, Routes.course_path(authed_conn, :delete, course))
      assert redirected_to(conn) == Routes.course_path(conn, :index)

      assert_error_sent 404, fn ->
        get(authed_conn, Routes.course_path(authed_conn, :show, course))
      end
    end
  end

  defp create_course(_) do
    course = insert(:course)
    {:ok, course: course}
  end
end
