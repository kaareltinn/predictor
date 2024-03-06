defmodule Predictor.PredictionsTest do
  use Predictor.DataCase

  alias Predictor.Predictions

  describe "predictions" do
    alias Predictor.Predictions.Prediction

    import Predictor.PredictionsFixtures

    @invalid_attrs %{home_goals: nil, away_goals: nil, home_penaltis: nil, away_penalties: nil}

    test "list_predictions/0 returns all predictions" do
      prediction = prediction_fixture()
      assert Predictions.list_predictions() == [prediction]
    end

    test "get_prediction!/1 returns the prediction with given id" do
      prediction = prediction_fixture()
      assert Predictions.get_prediction!(prediction.id) == prediction
    end

    test "create_prediction/1 with valid data creates a prediction" do
      valid_attrs = %{home_goals: 42, away_goals: 42, home_penaltis: 42, away_penalties: 42}

      assert {:ok, %Prediction{} = prediction} = Predictions.create_prediction(valid_attrs)
      assert prediction.home_goals == 42
      assert prediction.away_goals == 42
      assert prediction.home_penaltis == 42
      assert prediction.away_penalties == 42
    end

    test "create_prediction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Predictions.create_prediction(@invalid_attrs)
    end

    test "update_prediction/2 with valid data updates the prediction" do
      prediction = prediction_fixture()
      update_attrs = %{home_goals: 43, away_goals: 43, home_penaltis: 43, away_penalties: 43}

      assert {:ok, %Prediction{} = prediction} = Predictions.update_prediction(prediction, update_attrs)
      assert prediction.home_goals == 43
      assert prediction.away_goals == 43
      assert prediction.home_penaltis == 43
      assert prediction.away_penalties == 43
    end

    test "update_prediction/2 with invalid data returns error changeset" do
      prediction = prediction_fixture()
      assert {:error, %Ecto.Changeset{}} = Predictions.update_prediction(prediction, @invalid_attrs)
      assert prediction == Predictions.get_prediction!(prediction.id)
    end

    test "delete_prediction/1 deletes the prediction" do
      prediction = prediction_fixture()
      assert {:ok, %Prediction{}} = Predictions.delete_prediction(prediction)
      assert_raise Ecto.NoResultsError, fn -> Predictions.get_prediction!(prediction.id) end
    end

    test "change_prediction/1 returns a prediction changeset" do
      prediction = prediction_fixture()
      assert %Ecto.Changeset{} = Predictions.change_prediction(prediction)
    end
  end
end
