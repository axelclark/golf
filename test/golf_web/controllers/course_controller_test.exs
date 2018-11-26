defmodule GolfWeb.CourseControllerTest do
  use GolfWeb.ConnCase

  @create_attrs %{name: "some name", num_holes: 42}
  @update_attrs %{name: "some updated name", num_holes: 43}
  @invalid_attrs %{name: nil, num_holes: nil}

  describe "index" do
    setup [:create_course]

    test "lists all courses", %{conn: conn} do
      conn = get(conn, Routes.course_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Courses"
    end
  end

  describe "new course" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.course_path(conn, :new))
      assert html_response(conn, 200) =~ "New Course"
    end
  end

  describe "create course" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.course_path(conn, :create), course: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.course_path(conn, :show, id)

      conn = get(conn, Routes.course_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Course"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.course_path(conn, :create), course: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Course"
    end
  end

  describe "edit course" do
    setup [:create_course]

    test "renders form for editing chosen course", %{conn: conn, course: course} do
      conn = get(conn, Routes.course_path(conn, :edit, course))
      assert html_response(conn, 200) =~ "Edit Course"
    end
  end

  describe "update course" do
    setup [:create_course]

    test "redirects when data is valid", %{conn: conn, course: course} do
      conn = put(conn, Routes.course_path(conn, :update, course), course: @update_attrs)
      assert redirected_to(conn) == Routes.course_path(conn, :show, course)

      conn = get(conn, Routes.course_path(conn, :show, course))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, course: course} do
      conn = put(conn, Routes.course_path(conn, :update, course), course: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Course"
    end
  end

  describe "delete course" do
    setup [:create_course]

    test "deletes chosen course", %{conn: conn, course: course} do
      conn = delete(conn, Routes.course_path(conn, :delete, course))
      assert redirected_to(conn) == Routes.course_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.course_path(conn, :show, course))
      end
    end
  end

  defp create_course(_) do
    course = insert(:course)
    {:ok, course: course}
  end
end
