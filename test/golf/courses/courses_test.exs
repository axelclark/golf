defmodule Golf.CoursesTest do
  use Golf.DataCase

  alias Golf.Courses

  describe "courses" do
    alias Golf.Courses.Course

    @valid_attrs %{name: "some name", num_holes: 42}
    @update_attrs %{name: "some updated name", num_holes: 43}
    @invalid_attrs %{name: nil, num_holes: nil}

    test "list_courses/0 returns all courses" do
      course = insert(:course)
      assert Courses.list_courses() == [course]
    end

    test "get_course!/1 returns the course with given id" do
      course = insert(:course)
      assert Courses.get_course!(course.id).name == course.name
    end

    test "create_course/1 with valid data creates a course" do
      assert {:ok, %Course{} = course} = Courses.create_course(@valid_attrs)
      assert course.name == "some name"
      assert course.num_holes == 42
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_course(@invalid_attrs)
    end

    test "update_course/2 with valid data updates the course" do
      course = insert(:course)
      assert {:ok, %Course{} = course} = Courses.update_course(course, @update_attrs)
      assert course.name == "some updated name"
      assert course.num_holes == 43
    end

    test "update_course/2 with invalid data returns error changeset" do
      course = insert(:course)
      assert {:error, %Ecto.Changeset{}} = Courses.update_course(course, @invalid_attrs)
      assert course.name == Courses.get_course!(course.id).name
    end

    test "delete_course/1 deletes the course" do
      course = insert(:course)
      assert {:ok, %Course{}} = Courses.delete_course(course)
      assert_raise Ecto.NoResultsError, fn -> Courses.get_course!(course.id) end
    end

    test "change_course/1 returns a course changeset" do
      course = build(:course)
      assert %Ecto.Changeset{} = Courses.change_course(course)
    end
  end
end
