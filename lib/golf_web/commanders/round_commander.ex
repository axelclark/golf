defmodule GolfWeb.RoundCommander do
  use Drab.Commander

  alias Golf.Scorecard
  alias GolfWeb.RoundView

  defhandler increment(socket, sender, %{"id" => score_id}) do
    {:ok, score} = Scorecard.increment_score(score_id)
    send_score(socket, sender, score.num_strokes)
    update_round_total_score(socket, score)
  end

  defhandler decrement(socket, sender, %{"id" => score_id}) do
    {:ok, score} = Scorecard.decrement_score(score_id)
    send_score(socket, sender, score.num_strokes)
    update_round_total_score(socket, score)
  end

  defp send_score(socket, sender, num_strokes) do
    set_prop(socket, this_commander(sender) <> " .num_strokes",
      innerHTML: RoundView.display_strokes(num_strokes)
    )
  end

  defp update_round_total_score(socket, score) do
    round = Scorecard.get_round!(score.round_id)
    set_prop(socket, "#total_score", innerHTML: RoundView.display_score(round.total_score))
  end
end
