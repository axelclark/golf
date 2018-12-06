defmodule GolfWeb.Schema.ScorecardTypes do
  use Absinthe.Schema.Notation

  alias GolfWeb.Resolvers

  @desc "A round of golf"
  object :round do
    field :id, :id
    field :total_score, :integer
    field :course, :course
    field :course_id, :integer

    # field :scores, list_of(:score) do
    #   resolve(&Resolvers.Scorecard.scores_for_round/3)
    # end
  end

  @desc "Inputs to create a round"
  input_object :round_input do
    field :course_id, non_null(:integer)
  end

  @desc "A hole on a golf gourse"
  object :score do
    field :id, :id
    field :num_strokes, :integer
    field :hole, :hole
    field :hole_id, :integer
    field :round, :round
    field :round_id, :integer
  end
end
