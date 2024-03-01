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
      assert Competitions.get_competition!(competition.id) == competition
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

      assert competition == Competitions.get_competition!(competition.id)
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
    alias Predictor.Competitions.Match

    import Predictor.CompetitionsFixtures

    @invalid_attrs %{
      status: nil,
      home_goals: nil,
      away_goals: nil,
      home_penaltis: nil,
      away_penalties: nil,
      kickoff_at: nil
    }

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Competitions.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Competitions.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      valid_attrs = %{
        code: "some code",
        status: "scheduled",
        home_goals: 0,
        away_goals: 0,
        home_penaltis: 0,
        away_penalties: 0,
        kickoff_at: ~U[2024-02-28 21:58:00Z]
      }

      assert {:ok, %Match{} = match} = Competitions.create_match(valid_attrs)
      assert match.code == "some code"
      assert match.status == :scheduled
      assert match.home_goals == 0
      assert match.away_goals == 0
      assert match.home_penaltis == 0
      assert match.away_penalties == 0
      assert match.kickoff_at == ~U[2024-02-28 21:58:00Z]
    end

    test "create_match/1 with already existing code (case-insensitive) fails" do
      match = match_fixture()

      invalid_attrs = %{
        code: String.downcase(match.code),
        status: "scheduled",
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

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()

      update_attrs = %{
        status: "in_progress",
        home_goals: 0,
        away_goals: 0,
        home_penaltis: 0,
        away_penalties: 0,
        kickoff_at: ~U[2024-02-29 21:58:00Z]
      }

      assert {:ok, %Match{} = match} = Competitions.update_match(match, update_attrs)
      assert match.status == :in_progress
      assert match.home_goals == 0
      assert match.away_goals == 0
      assert match.home_penaltis == 0
      assert match.away_penalties == 0
      assert match.kickoff_at == ~U[2024-02-29 21:58:00Z]
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Competitions.update_match(match, @invalid_attrs)
      assert match == Competitions.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Competitions.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Competitions.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Competitions.change_match(match)
    end
  end
end
