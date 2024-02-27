defmodule Predictor.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Predictor.Teams` context.
  """

  @doc """
  Generate a unique team code.
  """
  def unique_team_code, do: "some code#{System.unique_integer([:positive])}"

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        code: unique_team_code(),
        name: "some name",
        type: "some type"
      })
      |> Predictor.Teams.create_team()

    team
  end
end
