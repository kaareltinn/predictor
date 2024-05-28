defmodule Predictor.Predictions.ScorerTest do
  use Predictor.DataCase

  import Predictor.CompetitionsFixtures
  import Predictor.AccountsFixtures
  import Predictor.PredictionsFixtures

  alias Predictor.Predictions.Scorer
  alias Predictor.Predictions
  alias Predictor.Competitions

  setup :setup_user_and_competition
  setup :setup_teams
  setup :setup_matches
  setup :setup_prediction_set

  describe "score/1" do
    test "scoring without predictions", %{prediction_set: prediction_set} do
      predictions = Predictions.list_predictions(prediction_set.id)
      assert Scorer.score(predictions) == 0
    end

    test "scoring when single prediction but no match finished yet", %{
      prediction_set: prediction_set,
      matches_by_code: matches
    } do
      prediction_set
      |> Predictions.add_prediction(%{
        match_id: get_match(matches, "WC2022:1").id,
        home_goals: 1,
        away_goals: 0
      })

      predictions = Predictions.list_predictions(prediction_set.id)
      assert Scorer.score(predictions) == 0
    end

    test "scoring when single prediction with finished group stage match", %{
      prediction_set: prediction_set,
      matches_by_code: matches
    } do
      match = get_match(matches, "WC2022:1")

      prediction_set
      |> Predictions.add_prediction(%{
        match_id: match.id,
        home_goals: 1,
        away_goals: 0
      })

      Competitions.update_match(match, %{status: :finished, home_goals: 1, away_goals: 0})

      predictions = Predictions.list_predictions(prediction_set.id)
      assert Scorer.score(predictions) == 10
    end

    test "scoring prediction with finished 1/8 stage match (both teams correct)", %{
      prediction_set: prediction_set,
      matches_by_code: matches,
      teams: teams
    } do
      match = get_match(matches, "WC2022:49")

      prediction_set
      |> Predictions.add_prediction(%{
        match_id: match.id,
        home_team_id: get_team(teams, "BRA").id,
        away_team_id: get_team(teams, "GER").id
      })

      Competitions.update_match(match, %{
        status: :finished,
        home_team_id: get_team(teams, "BRA").id,
        away_team_id: get_team(teams, "GER").id
      })

      predictions = Predictions.list_predictions(prediction_set.id)
      assert Scorer.score(predictions) == 30
    end

    test "scoring prediction with finished 1/8 stage match (one team correct, another wrong spot)",
         %{
           prediction_set: prediction_set,
           matches_by_code: matches,
           teams: teams
         } do
      match1 = get_match(matches, "WC2022:49")
      match2 = get_match(matches, "WC2022:50")

      prediction_set
      |> Predictions.add_prediction(%{
        match_id: match1.id,
        home_team_id: get_team(teams, "BRA").id,
        away_team_id: get_team(teams, "GER").id
      })
      |> Predictions.add_prediction(%{
        match_id: match2.id,
        home_team_id: get_team(teams, "NED").id,
        away_team_id: get_team(teams, "POR").id
      })

      Competitions.update_match(match1, %{
        status: :finished,
        # 15
        home_team_id: get_team(teams, "BRA").id,
        # 10
        away_team_id: get_team(teams, "NED").id
      })

      Competitions.update_match(match2, %{
        status: :finished,
        # 10
        home_team_id: get_team(teams, "POR").id,
        # 0
        away_team_id: get_team(teams, "ENG").id
      })

      predictions = Predictions.list_predictions(prediction_set.id)
      assert Scorer.score(predictions) == 35
    end

    test "scoring prediction with finished 1/4 stage matches",
         %{
           prediction_set: prediction_set,
           matches_by_code: matches,
           teams: teams
         } do
      match1 = get_match(matches, "WC2022:57")
      match2 = get_match(matches, "WC2022:58")
      match3 = get_match(matches, "WC2022:59")
      match4 = get_match(matches, "WC2022:60")

      prediction_set
      |> Predictions.add_prediction(%{
        match_id: match1.id,
        # 15
        home_team_id: get_team(teams, "BRA").id,
        # 15
        away_team_id: get_team(teams, "GER").id
      })
      |> Predictions.add_prediction(%{
        match_id: match2.id,
        # 0
        home_team_id: get_team(teams, "NED").id,
        # 0
        away_team_id: get_team(teams, "POR").id
      })
      |> Predictions.add_prediction(%{
        match_id: match3.id,
        # 15
        home_team_id: get_team(teams, "ESP").id,
        # 20
        away_team_id: get_team(teams, "ENG").id
      })
      |> Predictions.add_prediction(%{
        match_id: match4.id,
        # 15
        home_team_id: get_team(teams, "FRA").id,
        # 0
        away_team_id: get_team(teams, "ESP").id
      })

      Competitions.update_match(match1, %{
        status: :finished,
        home_team_id: get_team(teams, "GER").id,
        away_team_id: get_team(teams, "BRA").id
      })

      Competitions.update_match(match2, %{
        status: :finished,
        home_team_id: get_team(teams, "ESP").id,
        away_team_id: get_team(teams, "FRA").id
      })

      Competitions.update_match(match3, %{
        status: :finished,
        home_team_id: get_team(teams, "URU").id,
        away_team_id: get_team(teams, "ENG").id
      })

      Competitions.update_match(match4, %{
        status: :finished,
        home_team_id: get_team(teams, "URU").id,
        away_team_id: get_team(teams, "CRO").id
      })

      predictions = Predictions.list_predictions(prediction_set.id)
      assert Scorer.score(predictions) == 80
    end

    test "scoring prediction with finished 1/2 stage matches",
         %{
           prediction_set: prediction_set,
           matches_by_code: matches,
           teams: teams
         } do
      match1 = get_match(matches, "WC2022:61")
      match2 = get_match(matches, "WC2022:62")

      prediction_set
      |> Predictions.add_prediction(%{
        match_id: match1.id,
        # 25
        home_team_id: get_team(teams, "FRA").id,
        # 20
        away_team_id: get_team(teams, "GER").id
      })
      |> Predictions.add_prediction(%{
        match_id: match2.id,
        # 20
        home_team_id: get_team(teams, "ARG").id,
        # 0
        away_team_id: get_team(teams, "POR").id
      })

      Competitions.update_match(match1, %{
        status: :finished,
        home_team_id: get_team(teams, "FRA").id,
        away_team_id: get_team(teams, "ENG").id
      })

      Competitions.update_match(match2, %{
        status: :finished,
        home_team_id: get_team(teams, "GER").id,
        away_team_id: get_team(teams, "ARG").id
      })

      predictions = Predictions.list_predictions(prediction_set.id)
      assert Scorer.score(predictions) == 65
    end

    test "scoring prediction with finished third place match",
         %{
           prediction_set: prediction_set,
           matches_by_code: matches,
           teams: teams
         } do
      match1 = get_match(matches, "WC2022:63")

      prediction_set
      |> Predictions.add_prediction(%{
        match_id: match1.id,
        home_team_id: get_team(teams, "FRA").id,
        away_team_id: get_team(teams, "POR").id,
        home_goals: 3,
        away_goals: 1
      })

      Competitions.update_match(match1, %{
        status: :finished,
        home_team_id: get_team(teams, "FRA").id,
        away_team_id: get_team(teams, "ENG").id,
        home_goals: 2,
        away_goals: 1
      })

      predictions = Predictions.list_predictions(prediction_set.id)
      assert Scorer.score(predictions) == 26 + 30
    end

    test "scoring prediction with finished final place match",
         %{
           prediction_set: prediction_set,
           matches_by_code: matches,
           teams: teams
         } do
      match1 = get_match(matches, "WC2022:64")

      prediction_set
      |> Predictions.add_prediction(%{
        match_id: match1.id,
        home_team_id: get_team(teams, "FRA").id,
        away_team_id: get_team(teams, "POR").id,
        home_goals: 3,
        away_goals: 1
      })

      Competitions.update_match(match1, %{
        status: :finished,
        home_team_id: get_team(teams, "FRA").id,
        away_team_id: get_team(teams, "ENG").id,
        home_goals: 2,
        away_goals: 1
      })

      predictions = Predictions.list_predictions(prediction_set.id)
      assert Scorer.score(predictions) == 30 + 40
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
      |> Predictions.add_prediction(%{match_id: match1.id, home_goals: 2, away_goals: 1})
      |> Predictions.add_prediction(%{match_id: match2.id, home_goals: 1, away_goals: 2})
      |> Predictions.add_prediction(%{match_id: match3.id, home_goals: 1, away_goals: 1})
      |> Predictions.add_prediction(%{match_id: match4.id, home_goals: 1, away_goals: 0})

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

      predictions = Predictions.list_predictions(prediction_set.id)
      assert Scorer.score(predictions) == 23
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

  defp get_team(teams, team_code) do
    Enum.find(teams, fn team -> team.code == team_code end)
  end
end
