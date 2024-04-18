defmodule Predictor.CompetitionsTest do
  use Predictor.DataCase

  alias Predictor.Competitions

  describe "competitions" do
    alias Predictor.Competitions.Competition

    import Predictor.CompetitionsFixtures

    @invalid_attrs %{name: nil}

    test "list_competitions/0 returns all competitions" do
      competition = competition_fixture()
      assert Competitions.list_competitions() == [competition]
    end

    test "get_competition!/1 returns the competition with given id" do
      competition = competition_fixture()
      assert Competitions.get_competition!(competition.id).id == competition.id
    end

    test "create_competition/1 with valid data creates a competition" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Competition{} = competition} = Competitions.create_competition(valid_attrs)
      assert competition.name == "some name"
    end

    test "create_competition/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Competitions.create_competition(@invalid_attrs)
    end

    test "update_competition/2 with valid data updates the competition" do
      competition = competition_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Competition{} = competition} =
               Competitions.update_competition(competition, update_attrs)

      assert competition.name == "some updated name"
    end

    test "update_competition/2 with invalid data returns error changeset" do
      competition = competition_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Competitions.update_competition(competition, @invalid_attrs)

      assert competition.id == Competitions.get_competition!(competition.id).id
    end

    test "delete_competition/1 deletes the competition" do
      competition = competition_fixture()
      assert {:ok, %Competition{}} = Competitions.delete_competition(competition)
      assert_raise Ecto.NoResultsError, fn -> Competitions.get_competition!(competition.id) end
    end

    test "change_competition/1 returns a competition changeset" do
      competition = competition_fixture()
      assert %Ecto.Changeset{} = Competitions.change_competition(competition)
    end
  end

  describe "matches" do
    alias Predictor.Predictions
    alias Predictor.Competitions.Match

    import Predictor.AccountsFixtures
    import Predictor.CompetitionsFixtures
    import Predictor.PredictionsFixtures
    import Predictor.TeamsFixtures

    @invalid_attrs %{
      status: nil,
      home_goals: nil,
      away_goals: nil,
      home_penaltis: nil,
      away_penalties: nil,
      kickoff_at: nil
    }

    setup do
      competition = competition_fixture()

      home_team = team_fixture(%{name: "Netherlands", code: "NED", type: "national"})
      away_team = team_fixture(%{name: "Belgium", code: "BEL", type: "national"})

      match =
        match_fixture(%{competition: competition, home_team: home_team, away_team: away_team})

      {:ok, home_team: home_team, away_team: away_team, competition: competition, match: match}
    end

    setup context do
      user1 = user_fixture()
      user2 = user_fixture()

      prediction_set_1 =
        prediction_set_fixture(%{user: user1, competition: context.competition, name: "user_set1"})

      prediction_set_2 =
        prediction_set_fixture(%{user: user2, competition: context.competition, name: "user_set2"})

      user1_prediction =
        prediction_fixture(%{user: user1, match: context.match, prediction_set: prediction_set_1})

      user2_prediction =
        prediction_fixture(%{user: user2, match: context.match, prediction_set: prediction_set_2})

      {:ok,
       user1: user1,
       user2: user2,
       prediction_set_1: prediction_set_1,
       prediction_set_2: prediction_set_2,
       user1_prediction: user1_prediction,
       user2_prediction: user2_prediction}
    end

    test "list_matches/0 returns all matches", %{match: match} do
      assert Competitions.list_matches() == [match]
    end

    test "list_matches_with_predictions/2 returns all matches with user predictions", %{
      prediction_set_1: prediction_set_1,
      user1_prediction: user1_prediction
    } do
      [match] = Competitions.list_matches_with_predictions(prediction_set_1.id)
      assert match.user_prediction.id == user1_prediction.id
    end

    test "get_match!/1 returns the match with given id", %{match: match} do
      assert Competitions.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match", %{
      home_team: home_team,
      away_team: away_team,
      competition: competition
    } do
      valid_attrs = %{
        code: "some code",
        status: "scheduled",
        home_team: home_team,
        away_team: away_team,
        competition: competition,
        home_goals: 0,
        away_goals: 0,
        home_penaltis: 0,
        away_penalties: 0,
        kickoff_at: ~U[2024-02-28 21:58:00Z]
      }

      assert {:ok, %Match{} = match} = Competitions.create_match(valid_attrs)
      assert match.code == "some code"
      assert match.status == :scheduled
      assert match.competition == competition
      assert match.home_team == home_team
      assert match.away_team == away_team
      assert match.home_goals == 0
      assert match.away_goals == 0
      assert match.home_penaltis == 0
      assert match.away_penalties == 0
      assert match.kickoff_at == ~U[2024-02-28 21:58:00Z]
    end

    test "create_match/1 with already existing code (case-insensitive) fails", %{match: match} do
      invalid_attrs = %{
        code: String.downcase(match.code),
        status: "scheduled",
        home_team: team_fixture(),
        away_team: team_fixture(),
        competition: match.competition,
        home_goals: 0,
        away_goals: 0,
        home_penaltis: 0,
        away_penalties: 0,
        kickoff_at: ~U[2024-02-28 21:58:00Z]
      }

      assert {:error, %Ecto.Changeset{errors: [code: {"has already been taken", _}]}} =
               Competitions.create_match(invalid_attrs)
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Competitions.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match", %{match: match} do
      update_attrs = %{
        status: "in_progress",
        home_team: match.home_team,
        away_team: match.away_team,
        competition: match.competition,
        home_goals: 2,
        away_goals: 1,
        home_penaltis: 0,
        away_penalties: 0
      }

      assert {:ok, %Match{} = match} = Competitions.update_match(match, update_attrs)
      assert match.status == :in_progress
      assert match.home_goals == 2
      assert match.away_goals == 1
      assert match.home_penaltis == 0
      assert match.away_penalties == 0
    end

    test "update_match/2 with invalid data returns error changeset", %{match: match} do
      assert {:error, %Ecto.Changeset{}} = Competitions.update_match(match, @invalid_attrs)
      assert match == Competitions.get_match!(match.id)
    end

    test "delete_match/1 deletes the match and associated predictions",
         %{
           match: match,
           user1_prediction: user1_prediction,
           user2_prediction: user2_prediction
         } do
      assert {:ok, %Match{}} = Competitions.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Competitions.get_match!(match.id) end
      assert_raise Ecto.NoResultsError, fn -> Predictions.get_prediction!(user1_prediction.id) end
      assert_raise Ecto.NoResultsError, fn -> Predictions.get_prediction!(user2_prediction.id) end
    end

    test "delete_all_matches/1 deletes all matches by given competition",
         %{match: match} = context do
      another_competition = competition_fixture()

      another_match =
        match_fixture(%{
          code: "EURO2024:1",
          competition: another_competition,
          home_team: context[:home_team],
          away_team: context[:home_team]
        })

      assert {1, nil} = Competitions.delete_all_matches(another_competition.id)
      assert_raise Ecto.NoResultsError, fn -> Competitions.get_match!(another_match.id) end
      assert match == Competitions.get_match!(match.id)
    end

    test "change_match/1 returns a match changeset", %{match: match} do
      assert %Ecto.Changeset{} = Competitions.change_match(match)
    end
  end
end
