defmodule Predictor.Predictions.Scorer do
  @playoff_stages [:eigth, :quarter, :semi, :third, :final]
  @stage_points %{eigth: 15, quarter: 20, semi: 25, third: 26, final: 30}
  @winner_points %{third: 30, final: 40}

  def score(predictions) do
    predictions_by_stage = Enum.group_by(predictions, & &1.match.stage)

    [
      score_stage(predictions_by_stage[:group], :group),
      score_stage(predictions_by_stage[:eigth], :eigth),
      score_stage(predictions_by_stage[:quarter], :quarter),
      score_stage(predictions_by_stage[:semi], :semi),
      score_stage(predictions_by_stage[:third], :third),
      score_stage(predictions_by_stage[:final], :final),
      score_winner(predictions_by_stage[:third], :third),
      score_winner(predictions_by_stage[:final], :final)
    ]
    |> Enum.sum()
  end

  def score_stage(predictions, _) when is_nil(predictions), do: 0

  def score_stage(predictions, :group) do
    Enum.reduce(predictions, 0, fn prediction, acc ->
      acc + score_match(prediction)
    end)
  end

  def score_stage(predictions, stage) when stage in @playoff_stages do
    actual_teams =
      predictions
      |> Enum.flat_map(&[&1.match.home_team, &1.match.away_team])
      |> Enum.filter(& &1)
      |> Enum.map(& &1.code)

    state =
      Enum.reduce(predictions, %{score: 0, teams: MapSet.new()}, fn prediction, acc ->
        {score, teams} = score_match(prediction)

        %{
          acc
          | score: acc.score + score,
            teams: MapSet.union(acc.teams, MapSet.new(teams))
        }
      end)

    state.score + score_teams(stage, state.teams, actual_teams)
  end

  defp score_match(%{match: %{stage: stage, status: :scheduled}}) when stage in @playoff_stages do
    {0, []}
  end

  defp score_match(%{match: %{stage: :group, status: :scheduled}}) do
    0
  end

  defp score_match(%{match: %{stage: :group, status: :finished}} = prediction) do
    case {result(prediction), result(prediction.match)} do
      {:home_win, :home_win} -> compute_score(prediction)
      {:away_win, :away_win} -> compute_score(prediction)
      {:draw, :draw} -> compute_score(prediction)
      _ -> 0
    end
  end

  defp score_match(%{match: %{stage: stage, status: :finished}} = prediction)
       when stage in @playoff_stages do
    points = @stage_points[stage]

    cond do
      prediction.home_team.code == prediction.match.home_team.code &&
          prediction.away_team.code == prediction.match.away_team.code ->
        {points * 2, []}

      prediction.home_team.code == prediction.match.home_team.code ->
        {points, [prediction.away_team.code]}

      prediction.away_team.code == prediction.match.away_team.code ->
        {points, [prediction.home_team.code]}

      true ->
        {0, [prediction.home_team.code, prediction.away_team.code]}
    end
  end

  defp score_teams(stage, predicted_teams, actual_teams) do
    MapSet.intersection(predicted_teams, MapSet.new(actual_teams))
    |> MapSet.to_list()
    |> Enum.count()
    |> Kernel.*(@stage_points[stage] - 5)
  end

  defp score_winner(predictions, stage) do
    with [%{match: %{status: :finished} = match} = prediction] <- predictions do
      case {result(match), result(prediction.match)} do
        {:home_win, :home_win} -> @winner_points[stage]
        {:away_win, :away_win} -> @winner_points[stage]
        _ -> 0
      end
    else
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

  defp compute_score(prediction) do
    10 - abs(prediction.match.home_goals - prediction.home_goals) -
      abs(prediction.match.away_goals - prediction.away_goals)
  end
end
