defmodule GolfWeb.RoundView do
  use GolfWeb, :view

  def display_score(score) when score < 0, do: score

  def display_score(score) when score == 0, do: "Even"

  def display_score(score) when score > 0, do: "+#{score}"

  def display_strokes(strokes) when strokes < 1, do: ""

  def display_strokes(strokes), do: strokes
end
