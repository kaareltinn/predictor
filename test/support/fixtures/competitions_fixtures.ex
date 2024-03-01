defmodule Predictor.CompetitionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Predictor.Competitions` context.
  """

  @doc """
  Generate a competition.
  """
  def competition_fixture(attrs \\ %{}) do
    {:ok, competition} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Predictor.Competitions.create_competition()

    competition
  end

  @doc """
  Generate a match.
  """
  def match_fixture(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(%{
        code: "WC2022:1",
        away_goals: 1,
        away_penalties: 0,
        home_goals: 2,
        home_penaltis: 0,
        kickoff_at: ~U[2024-02-28 21:58:00Z],
        status: "scheduled"
      })
      |> Predictor.Competitions.create_match()

    match
  end
end
