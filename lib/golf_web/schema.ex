defmodule GolfWeb.Schema do
  use Absinthe.Schema
  import_types(__MODULE__.CoursesTypes)
  import_types(__MODULE__.ScorecardTypes)
  import_types(Absinthe.Phoenix.Types)

  alias Golf.Courses
  alias GolfWeb.Resolvers

  mutation do
    @desc "Create a round"
    field :create_round, :round do
      arg(:input, non_null(:round_input))
      resolve(&Resolvers.Scorecard.create_round/3)
    end

    @desc "Update a score"
    field :update_score, :score do
      arg(:id, non_null(:id))
      arg(:input, non_null(:score_input))
      resolve(&Resolvers.Scorecard.update_score/3)
    end
  end

  query do
    @desc "The list of golf courses"
    field :courses, list_of(:course) do
      resolve(&Resolvers.Courses.list_courses/3)
    end

    @desc "The list of rounds"
    field :rounds, list_of(:round) do
      resolve(&Resolvers.Scorecard.list_rounds/3)
    end

    @desc "Get a round"
    field :round, :round do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Scorecard.get_round/3)
    end
  end

  scalar :date do
    parse(fn input ->
      case Date.from_iso8601(input.value) do
        {:ok, date} -> {:ok, date}
        _ -> :error
      end
    end)

    serialize(fn date ->
      Date.to_iso8601(date)
    end)
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
