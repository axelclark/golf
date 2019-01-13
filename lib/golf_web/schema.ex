defmodule GolfWeb.Schema do
  use Absinthe.Schema
  import_types(__MODULE__.CoursesTypes)
  import_types(__MODULE__.ScorecardTypes)
  import_types(__MODULE__.AccountsTypes)
  import_types(Absinthe.Phoenix.Types)

  alias Golf.Courses
  alias GolfWeb.Resolvers

  mutation do
    @desc "Create a course"
    field :create_course, :course do
      arg(:input, non_null(:course_input))
      resolve(&Resolvers.Courses.create_course/3)
    end

    @desc "Create a round"
    field :create_round, :round do
      arg(:input, non_null(:round_input))
      resolve(&Resolvers.Scorecard.create_round/3)
    end

    @desc "Delete a round"
    field :delete_round, :round do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Scorecard.delete_round/3)
    end

    @desc "Register a user"
    field :create_user, :session do
      arg(:input, non_null(:user_input))
      resolve(&Resolvers.Accounts.create_user/3)
    end

    @desc "Log in a user"
    field :login, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.login/3)
    end

    @desc "Update a course"
    field :update_course, :course do
      arg(:id, non_null(:id))
      arg(:input, non_null(:course_input))
      resolve(&Resolvers.Courses.update_course/3)
    end

    @desc "Update a score"
    field :update_score, :score do
      arg(:id, non_null(:id))
      arg(:input, non_null(:score_input))
      resolve(&Resolvers.Scorecard.update_score/3)
    end

    @desc "Resets a password"
    field :reset_password, :user_email do
      arg(:email, non_null(:string))
      resolve(&Resolvers.Accounts.create_reset_token/3)
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
