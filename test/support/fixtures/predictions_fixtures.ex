defmodule Predictor.PredictionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Predictor.Predictions` context.
  """

  import Predictor.AccountsFixtures
  import Predictor.CompetitionsFixtures

  @doc """
  Generate a prediction.
  """
  def prediction_fixture(attrs \\ %{}) do
    {:ok, prediction} =
      attrs
      |> Enum.into(%{
        away_goals: 2,
        away_penalties: 0,
        home_goals: 1,
        home_penaltis: 0
      })
      |> Predictor.Predictions.create_prediction()

    prediction
  end

  @doc """
  Generate a prediction_set.
  """
  def prediction_set_fixture(attrs \\ %{}) do
    {:ok, prediction_set} =
      attrs
      |> Enum.into(%{
        user: attrs[:user] || user_fixture(),
        competition: attrs[:competition] || competition_fixture(),
        name: "some prediction set"
      })
      |> Predictor.Predictions.create_prediction_set()

    prediction_set
  end
end
