defmodule Predictor.LeaguesTest do
  use Predictor.DataCase

  alias Predictor.Leagues

  import Predictor.LeaguesFixtures
  import Predictor.CompetitionsFixtures

  describe "leagues" do
    alias Predictor.Leagues.League

    @invalid_attrs %{name: nil, entry_code: nil}

    setup [:setup_league]

    test "list_leagues/0 returns all leagues", %{league: league} do
      assert Leagues.list_leagues() == [league]
    end

    test "get_league!/1 returns the league with given id", %{league: league} do
      assert Leagues.get_league!(league.id).id == league.id
    end

    test "create_league/1 with valid data creates a league", %{competition: competition} do
      valid_attrs = %{
        name: "some name",
        entry_code: "some other entry_code",
        competition_id: competition.id
      }

      assert {:ok, %League{} = league} = Leagues.create_league(valid_attrs)
      assert league.name == "some name"
      assert league.entry_code == "some other entry_code"
    end

    test "create_league/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leagues.create_league(@invalid_attrs)
    end

    test "update_league/2 with valid data updates the league", %{league: league} do
      update_attrs = %{name: "some updated name", entry_code: "some updated entry_code"}

      assert {:ok, %League{} = league} = Leagues.update_league(league, update_attrs)
      assert league.name == "some updated name"
      assert league.entry_code == "some updated entry_code"
    end

    test "update_league/2 with invalid data returns error changeset", %{league: league} do
      assert {:error, %Ecto.Changeset{}} = Leagues.update_league(league, @invalid_attrs)
    end

    test "delete_league/1 deletes the league", %{league: league} do
      assert {:ok, %League{}} = Leagues.delete_league(league)
      assert_raise Ecto.NoResultsError, fn -> Leagues.get_league!(league.id) end
    end

    test "change_league/1 returns a league changeset", %{league: league} do
      assert %Ecto.Changeset{} = Leagues.change_league(league)
    end
  end

  defp setup_league(context) do
    competition = competition_fixture()
    league = league_fixture(%{competition_id: competition.id})
    Map.merge(context, %{league: league, competition: competition})
  end
end
