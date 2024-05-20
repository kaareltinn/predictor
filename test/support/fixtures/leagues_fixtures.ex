defmodule Predictor.LeaguesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Predictor.Leagues` context.
  """

  @doc """
  Generate a league.
  """
  def league_fixture(attrs \\ %{}) do
    {:ok, league} =
      attrs
      |> Enum.into(%{
        entry_code: "some entry_code",
        name: "some name"
      })
      |> Predictor.Leagues.create_league()

    league
  end
end
