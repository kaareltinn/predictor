defmodule Predictor.PredictionsTest do
  use Predictor.DataCase

  alias Predictor.Predictions

  describe "predictions" do
    alias Predictor.Predictions.Prediction

    import Predictor.PredictionsFixtures
    import Predictor.CompetitionsFixtures
    import Predictor.AccountsFixtures
    import Predictor.TeamsFixtures

    @invalid_attrs %{home_goals: nil, away_goals: nil, home_penaltis: nil, away_penalties: nil}

    setup do
      user = user_fixture()
      competition = competition_fixture()

      home_team = team_fixture(%{name: "Netherlands", code: "NED", type: "national"})
      away_team = team_fixture(%{name: "Belgium", code: "BEL", type: "national"})

      match =
        match_fixture(%{competition: competition, home_team: home_team, away_team: away_team})

      [
        user: user,
        competition: competition,
        match: match
      ]
    end

    test "list_predictions/0 returns all predictions", %{user: user, match: match} do
      prediction = prediction_fixture(%{user: user, match: match})
      assert [^prediction] = Predictions.list_predictions()
    end

    test "get_prediction!/1 returns the prediction with given id", %{user: user, match: match} do
      prediction = prediction_fixture(%{user: user, match: match})
      assert Predictions.get_prediction!(prediction.id) == prediction
    end

    test "create_prediction/1 with valid data creates a prediction", %{user: user, match: match} do
      valid_attrs = %{home_goals: 1, away_goals: 2, user: user, match: match}

      assert {:ok, %Prediction{} = prediction} = Predictions.create_prediction(valid_attrs)
      assert prediction.home_goals == 1
      assert prediction.away_goals == 2
      assert prediction.home_penaltis == 0
      assert prediction.away_penalties == 0
      assert prediction.user == user
      assert prediction.match == match
    end

    test "create_prediction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Predictions.create_prediction(@invalid_attrs)
    end

    test "update_prediction/2 with valid data updates the prediction", %{user: user, match: match} do
      prediction = prediction_fixture(%{user: user, match: match})
      update_attrs = %{home_goals: 2}

      assert {:ok, %Prediction{} = prediction} =
               Predictions.update_prediction(prediction, update_attrs)

      assert prediction.home_goals == 2
      assert prediction.away_goals == 2
      assert prediction.home_penaltis == 0
      assert prediction.away_penalties == 0
    end

    test "update_prediction/2 with invalid data returns error changeset", %{match: match} do
      prediction = prediction_fixture(%{user: user_fixture(), match: match})

      assert {:error, %Ecto.Changeset{}} =
               Predictions.update_prediction(prediction, @invalid_attrs)

      assert prediction == Predictions.get_prediction!(prediction.id)
    end

    test "delete_prediction/1 deletes the prediction", %{match: match} do
      prediction = prediction_fixture(%{user: user_fixture(), match: match})
      assert {:ok, %Prediction{}} = Predictions.delete_prediction(prediction)
      assert_raise Ecto.NoResultsError, fn -> Predictions.get_prediction!(prediction.id) end
    end

    test "change_prediction/1 returns a prediction changeset", %{match: match} do
      prediction = prediction_fixture(%{user: user_fixture(), match: match})
      assert %Ecto.Changeset{} = Predictions.change_prediction(prediction)
    end
  end

  describe "prediction_sets" do
    alias Predictor.Predictions.PredictionSet

    import Predictor.PredictionsFixtures

    @invalid_attrs %{name: nil}

    test "list_prediction_sets/0 returns all prediction_sets" do
      prediction_set = prediction_set_fixture()
      assert Predictions.list_prediction_sets() == [prediction_set]
    end

    test "get_prediction_set!/1 returns the prediction_set with given id" do
      prediction_set = prediction_set_fixture()
      assert Predictions.get_prediction_set!(prediction_set.id) == prediction_set
    end

    test "create_prediction_set/1 with valid data creates a prediction_set" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %PredictionSet{} = prediction_set} = Predictions.create_prediction_set(valid_attrs)
      assert prediction_set.name == "some name"
    end

    test "create_prediction_set/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Predictions.create_prediction_set(@invalid_attrs)
    end

    test "update_prediction_set/2 with valid data updates the prediction_set" do
      prediction_set = prediction_set_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %PredictionSet{} = prediction_set} = Predictions.update_prediction_set(prediction_set, update_attrs)
      assert prediction_set.name == "some updated name"
    end

    test "update_prediction_set/2 with invalid data returns error changeset" do
      prediction_set = prediction_set_fixture()
      assert {:error, %Ecto.Changeset{}} = Predictions.update_prediction_set(prediction_set, @invalid_attrs)
      assert prediction_set == Predictions.get_prediction_set!(prediction_set.id)
    end

    test "delete_prediction_set/1 deletes the prediction_set" do
      prediction_set = prediction_set_fixture()
      assert {:ok, %PredictionSet{}} = Predictions.delete_prediction_set(prediction_set)
      assert_raise Ecto.NoResultsError, fn -> Predictions.get_prediction_set!(prediction_set.id) end
    end

    test "change_prediction_set/1 returns a prediction_set changeset" do
      prediction_set = prediction_set_fixture()
      assert %Ecto.Changeset{} = Predictions.change_prediction_set(prediction_set)
    end
  end
end
