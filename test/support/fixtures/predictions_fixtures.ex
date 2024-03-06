defmodule Predictor.PredictionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Predictor.Predictions` context.
  """

  @doc """
  Generate a prediction.
  """
  def prediction_fixture(attrs \\ %{}) do
    {:ok, prediction} =
      attrs
      |> Enum.into(%{
        away_goals: 42,
        away_penalties: 42,
        home_goals: 42,
        home_penaltis: 42
      })
      |> Predictor.Predictions.create_prediction()

    prediction
  end
end
