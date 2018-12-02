defmodule Golf.CoursesTest do
  use Golf.DataCase

  alias Golf.Courses

  describe "courses" do
    alias Golf.Courses.Course

    @valid_course_attrs %{name: "some name", num_holes: 9}
    @update_course_attrs %{name: "some updated name", num_holes: 18}
    @invalid_course_attrs %{name: nil, num_holes: nil}

    test "list_courses/0 returns all courses" do
      course = insert(:course)
      assert Courses.list_courses() == [course]
    end

    test "get_course!/1 returns the course with given id" do
      course = insert(:course)
      assert Courses.get_course!(course.id).name == course.name
    end

    test "create_course/1 with valid data creates a course and holes" do
      assert {:ok, %Course{} = result} = Courses.create_course(@valid_course_attrs)
      course = Courses.get_course!(result.id)

      assert course.name == "some name"
      assert course.num_holes == 9
      assert Enum.count(course.holes) == 9
    end

    test "create_course/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_course(@invalid_course_attrs)
    end

    test "update_course/2 with valid data updates the course" do
      course = insert(:course)
      assert {:ok, %Course{} = course} = Courses.update_course(course, @update_course_attrs)
      assert course.name == "some updated name"
      assert course.num_holes == 18
    end

    test "update_course/2 with invalid data returns error changeset" do
      course = insert(:course)
      assert {:error, %Ecto.Changeset{}} = Courses.update_course(course, @invalid_course_attrs)
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

  describe "holes" do
    alias Golf.Courses.Hole

    test "create_hole/1 with valid data creates a hole" do
      course = insert(:course)
      default_par = 3
      attrs = %{hole_number: 1, course_id: course.id}

      assert {:ok, %Hole{} = result} = Courses.create_hole(attrs)

      assert result.hole_number == 1
      assert result.par == default_par
      assert result.course_id == course.id
    end

    test "create_hole/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Courses.create_hole(%{})
    end
  end
end
