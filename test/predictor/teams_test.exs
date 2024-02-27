defmodule Predictor.TeamsTest do
  use Predictor.DataCase

  alias Predictor.Teams

  describe "teams" do
    alias Predictor.Teams.Team

    import Predictor.TeamsFixtures

    @invalid_attrs %{code: nil, name: nil, type: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Teams.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Teams.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{code: "some code", name: "some name", type: "some type"}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.code == "some code"
      assert team.name == "some name"
      assert team.type == "some type"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{code: "some updated code", name: "some updated name", type: "some updated type"}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.code == "some updated code"
      assert team.name == "some updated name"
      assert team.type == "some updated type"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end
end
