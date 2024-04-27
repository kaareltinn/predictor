defmodule Predictor.Predictions.Scorer do
  def score(matches_with_predictions) do
    Enum.reduce(matches_with_predictions, 0, fn match, acc ->
      acc + score_match(match)
    end)
  end

  defp score_match(%{status: :scheduled}) do
    0
  end

  defp score_match(match) do
    case {result(match), result(match.user_prediction)} do
      {:home_win, :home_win} -> compute_score(match)
      {:away_win, :away_win} -> compute_score(match)
      {:draw, :draw} -> compute_score(match)
      _ -> 0
    end
  end

  defp result(%{home_goals: home_goals, away_goals: away_goals}) do
    cond do
      home_goals > away_goals -> :home_win
      home_goals < away_goals -> :away_win
      home_goals == away_goals -> :draw
    end
  end

  defp compute_score(match) do
    10 - abs(match.user_prediction.home_goals - match.home_goals) -
      abs(match.user_prediction.away_goals - match.away_goals)
  end
end
