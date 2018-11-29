defmodule GolfWeb.Schema do
  use Absinthe.Schema
  import_types(__MODULE__.CoursesTypes)
  import_types(Absinthe.Phoenix.Types)

  alias Golf.Courses
  alias GolfWeb.Resolvers

  @desc "The list of golf courses"
  query do
    field :courses, list_of(:course) do
      resolve(&Resolvers.Courses.list_courses/3)
    end
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Courses, Courses.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
