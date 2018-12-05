defmodule GolfWeb.RoundCommander do
  use Drab.Commander

  defhandler increment(socket, sender, %{"id" => score_id}) do
    {:ok, %{num_strokes: num_strokes}} = Golf.Scorecard.increment_score(score_id)
    send_data(socket, sender, num_strokes)
  end

  defhandler decrement(socket, sender, %{"id" => score_id}) do
    {:ok, %{num_strokes: num_strokes}} = Golf.Scorecard.decrement_score(score_id)
    send_data(socket, sender, num_strokes)
  end

  defp send_data(socket, sender, num_strokes) do
    set_prop(socket, this_commander(sender) <> " .num_strokes",
      innerHTML: display_strokes(num_strokes)
    )
  end

  defp display_strokes(strokes) when strokes < 1, do: ""

  defp display_strokes(strokes), do: strokes
end
