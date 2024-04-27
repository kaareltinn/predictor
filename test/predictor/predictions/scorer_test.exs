defmodule Predictor.Predictions.ScorerTest do
  use Predictor.DataCase

  import Predictor.CompetitionsFixtures
  import Predictor.AccountsFixtures
  import Predictor.PredictionsFixtures

  alias Predictor.Predictions.Scorer
  alias Predictor.Predictions
  alias Predictor.Competitions
  alias Predictor.Competitions.Match
  alias Predictor.Teams

  setup :setup_user_and_competition
  setup :setup_teams
  setup :setup_matches
  setup :setup_prediction_set

  describe "score/1" do
    test "scoring without predictions", %{prediction_set: prediction_set} do
      matches = Competitions.list_matches_with_predictions(prediction_set.id)
      assert Scorer.score(matches) == 0
    end

    test "scoring when single prediction but no matches finished yet", %{
      prediction_set: prediction_set,
      matches_by_code: matches
    } do
      prediction_set
      |> Predictions.add_prediction(%{
        match: get_match(matches, "WC2022:1"),
        home_goals: 1,
        away_goals: 0
      })

      matches = Competitions.list_matches_with_predictions(prediction_set.id)
      assert Scorer.score(matches) == 0
    end

    test "scoring when single prediction with finished match", %{
      prediction_set: prediction_set,
      matches_by_code: matches
    } do
      match = get_match(matches, "WC2022:1")

      prediction_set
      |> Predictions.add_prediction(%{
        match: match,
        home_goals: 1,
        away_goals: 0
      })

      Competitions.update_match(match, %{status: :finished, home_goals: 1, away_goals: 0})

      matches = Competitions.list_matches_with_predictions(prediction_set.id)
      assert Scorer.score(matches) == 10
    end

    test "scoring when multiple predictions and results", %{
      prediction_set: prediction_set,
      matches_by_code: matches
    } do
      match1 = get_match(matches, "WC2022:1")
      match2 = get_match(matches, "WC2022:2")
      match3 = get_match(matches, "WC2022:3")
      match4 = get_match(matches, "WC2022:4")

      prediction_set
      |> Predictions.add_prediction(%{match: match1, home_goals: 2, away_goals: 1})
      |> Predictions.add_prediction(%{match: match2, home_goals: 1, away_goals: 2})
      |> Predictions.add_prediction(%{match: match3, home_goals: 1, away_goals: 1})
      |> Predictions.add_prediction(%{match: match4, home_goals: 1, away_goals: 0})

      match1
      # 8
      |> Competitions.update_match(%{status: :finished, home_goals: 1, away_goals: 0})

      match2
      # 9
      |> Competitions.update_match(%{status: :finished, home_goals: 0, away_goals: 2})

      match3
      # 6
      |> Competitions.update_match(%{status: :finished, home_goals: 3, away_goals: 3})

      match4
      # 0
      |> Competitions.update_match(%{status: :finished, home_goals: 1, away_goals: 2})

      matches = Competitions.list_matches_with_predictions(prediction_set.id)
      assert Scorer.score(matches) == 23
    end
  end

  defp setup_user_and_competition(context) do
    user = user_fixture()
    competition = competition_fixture(%{name: "WC2022"})

    Map.merge(context, %{user: user, competition: competition})
  end

  defp setup_teams(context) do
    teams = Predictor.Competitions.DataImporter.import_teams(context.competition)
    Map.merge(context, %{teams: teams})
  end

  defp setup_matches(context) do
    matches = Predictor.Competitions.DataImporter.import_matches(context.competition)
    Map.merge(context, %{matches_by_code: matches |> Enum.group_by(& &1.code)})
  end

  defp setup_prediction_set(context) do
    prediction_set =
      prediction_set_fixture(%{user: context.user, competition: context.competition})

    Map.merge(context, %{prediction_set: prediction_set})
  end

  defp get_match(matches, code) do
    [match] = matches[code]
    match
  end

  defp get_team(teams, code) do
    Enum.find(teams, fn team -> team.code == code end)
  end
end
