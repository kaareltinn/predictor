defmodule Predictor.Predictions.Scorer do
  @playoff_stages [:eigth, :quarter, :semi, :third, :final]
  @stage_points %{eigth: 15, quarter: 20, semi: 25, third: 26, final: 30}
  @winner_points %{third: 30, final: 40}

  def score(matches_with_predictions) do
    matches_by_stage = Enum.group_by(matches_with_predictions, & &1.stage)

    [
      score_stage(matches_by_stage, :group),
      score_stage(matches_by_stage, :eigth),
      score_stage(matches_by_stage, :quarter),
      score_stage(matches_by_stage, :semi),
      score_stage(matches_by_stage, :third),
      score_stage(matches_by_stage, :final),
      score_winner(matches_by_stage, :third),
      score_winner(matches_by_stage, :final)
    ]
    |> Enum.sum()
  end

  def score_stage(matches, :group) do
    Enum.reduce(matches[:group], 0, fn match, acc ->
      acc + score_match(match)
    end)
  end

  def score_stage(matches, stage) when stage in @playoff_stages do
    stage_matches = matches[stage]

    actual_teams =
      stage_matches
      |> Enum.flat_map(&[&1.home_team, &1.away_team])
      |> Enum.filter(& &1)
      |> Enum.map(& &1.code)

    state =
      Enum.reduce(stage_matches, %{score: 0, teams: MapSet.new()}, fn match, acc ->
        {score, teams} = score_match(match)

        %{
          acc
          | score: acc.score + score,
            teams: MapSet.union(acc.teams, MapSet.new(teams))
        }
      end)

    state.score + score_teams(stage, state.teams, actual_teams)
  end

  defp score_match(%{stage: stage, status: :scheduled}) when stage in @playoff_stages do
    {0, []}
  end

  defp score_match(%{stage: :group, status: :scheduled}) do
    0
  end

  defp score_match(%{stage: :group, status: :finished} = match) do
    case {result(match), result(match.user_prediction)} do
      {:home_win, :home_win} -> compute_score(match)
      {:away_win, :away_win} -> compute_score(match)
      {:draw, :draw} -> compute_score(match)
      _ -> 0
    end
  end

  defp score_match(%{stage: stage, status: :finished} = match)
       when stage in @playoff_stages do
    points = @stage_points[stage]

    cond do
      match.home_team.code == match.user_prediction.home_team.code &&
          match.away_team.code == match.user_prediction.away_team.code ->
        {points * 2, []}

      match.home_team.code == match.user_prediction.home_team.code ->
        {points, [match.user_prediction.away_team.code]}

      match.away_team.code == match.user_prediction.away_team.code ->
        {points, [match.user_prediction.home_team.code]}

      true ->
        {0, [match.user_prediction.home_team.code, match.user_prediction.away_team.code]}
    end
  end

  defp score_teams(stage, predicted_teams, actual_teams) do
    MapSet.intersection(predicted_teams, MapSet.new(actual_teams))
    |> MapSet.to_list()
    |> Enum.count()
    |> Kernel.*(@stage_points[stage] - 5)
  end

  defp score_winner(matches, stage) do
    with [%{status: :finished} = match] <- matches[stage] do
      case {result(match), result(match.user_prediction)} do
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

  defp compute_score(match) do
    10 - abs(match.user_prediction.home_goals - match.home_goals) -
      abs(match.user_prediction.away_goals - match.away_goals)
  end
end
