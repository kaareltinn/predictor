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
end
