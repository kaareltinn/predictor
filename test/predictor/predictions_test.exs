defmodule Predictor.PredictionsTest do
  use Predictor.DataCase

  alias Predictor.Predictions

  import Predictor.PredictionsFixtures
  import Predictor.CompetitionsFixtures
  import Predictor.AccountsFixtures
  import Predictor.TeamsFixtures

  describe "predictions" do
    alias Predictor.Predictions.Prediction

    @invalid_attrs %{home_goals: nil, away_goals: nil, home_penaltis: nil, away_penalties: nil}

    setup :setup_user_and_competition

    setup context do
      prediction_set =
        prediction_set_fixture(%{user: context.user, competition: context.competition})

      home_team = team_fixture(%{name: "Netherlands", code: "NED", type: "national"})
      away_team = team_fixture(%{name: "Belgium", code: "BEL", type: "national"})

      match =
        match_fixture(%{
          competition: context.competition,
          home_team: home_team,
          away_team: away_team
        })

      [
        prediction_set: prediction_set,
        match: match
      ]
    end

    test "list_predictions/0 returns all predictions", %{
      user: user,
      prediction_set: prediction_set,
      match: match
    } do
      prediction = prediction_fixture(%{user: user, prediction_set: prediction_set, match: match})
      assert Predictions.list_predictions() |> Enum.map(& &1.id) == [prediction.id]
    end

    test "get_prediction!/1 returns the prediction with given id", %{
      user: user,
      prediction_set: prediction_set,
      match: match
    } do
      prediction = prediction_fixture(%{user: user, prediction_set: prediction_set, match: match})
      assert Predictions.get_prediction!(prediction.id).id == prediction.id
    end

    test "create_prediction/1 with valid data creates a prediction", %{
      user: user,
      prediction_set: prediction_set,
      match: match
    } do
      valid_attrs = %{
        home_goals: 1,
        away_goals: 2,
        user: user,
        prediction_set: prediction_set,
        match: match
      }

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

    test "update_prediction/2 with valid data updates the prediction", %{
      user: user,
      prediction_set: prediction_set,
      match: match
    } do
      prediction = prediction_fixture(%{user: user, prediction_set: prediction_set, match: match})
      update_attrs = %{home_goals: 2}

      assert {:ok, %Prediction{} = prediction} =
               Predictions.update_prediction(prediction, update_attrs)

      assert prediction.home_goals == 2
      assert prediction.away_goals == 2
      assert prediction.home_penaltis == 0
      assert prediction.away_penalties == 0
    end

    test "update_prediction/2 with invalid data returns error changeset", %{
      user: user,
      prediction_set: prediction_set,
      match: match
    } do
      prediction = prediction_fixture(%{user: user, prediction_set: prediction_set, match: match})

      assert {:error, %Ecto.Changeset{}} =
               Predictions.update_prediction(prediction, @invalid_attrs)
    end

    test "delete_prediction/1 deletes the prediction", %{
      user: user,
      prediction_set: prediction_set,
      match: match
    } do
      prediction = prediction_fixture(%{user: user, prediction_set: prediction_set, match: match})
      assert {:ok, %Prediction{}} = Predictions.delete_prediction(prediction)
      assert_raise Ecto.NoResultsError, fn -> Predictions.get_prediction!(prediction.id) end
    end

    test "change_prediction/1 returns a prediction changeset", %{
      user: user,
      prediction_set: prediction_set,
      match: match
    } do
      prediction = prediction_fixture(%{user: user, prediction_set: prediction_set, match: match})
      assert %Ecto.Changeset{} = Predictions.change_prediction(prediction)
    end
  end

  describe "prediction_sets" do
    alias Predictor.Predictions.PredictionSet

    import Predictor.PredictionsFixtures

    setup :setup_user_and_competition

    test "list_prediction_sets/0 returns all prediction_sets", %{
      user: user,
      competition: competition
    } do
      prediction_set = prediction_set_fixture(%{user: user, competition: competition})
      assert Predictions.list_prediction_sets() |> Enum.map(& &1.id) == [prediction_set.id]
    end

    test "get_prediction_set!/1 returns the prediction_set with given id", %{
      user: user,
      competition: competition
    } do
      prediction_set = prediction_set_fixture(%{user: user, competition: competition})
      assert Predictions.get_prediction_set!(prediction_set.id).id == prediction_set.id
    end

    test "create_prediction_set/1 with valid data creates a prediction_set", %{
      user: user,
      competition: competition
    } do
      valid_attrs = %{name: "some name", user: user, competition: competition}

      assert {:ok, %PredictionSet{} = prediction_set} =
               Predictions.create_prediction_set(valid_attrs)

      assert prediction_set.name == "some name"
    end

    test "create_prediction_set/1 with invalid data returns error changeset", %{
      user: user,
      competition: competition
    } do
      assert {:error, %Ecto.Changeset{}} =
               Predictions.create_prediction_set(%{
                 user: user,
                 competition: competition,
                 name: nil
               })
    end

    test "update_prediction_set/2 with valid data updates the prediction_set", %{
      user: user,
      competition: competition
    } do
      prediction_set = prediction_set_fixture(%{user: user, competition: competition})
      update_attrs = %{name: "some updated name"}

      assert {:ok, %PredictionSet{} = prediction_set} =
               Predictions.update_prediction_set(prediction_set, update_attrs)

      assert prediction_set.name == "some updated name"
    end

    test "update_prediction_set/2 with invalid data returns error changeset", %{
      user: user,
      competition: competition
    } do
      prediction_set = prediction_set_fixture(%{user: user, competition: competition})

      assert {:error, %Ecto.Changeset{}} =
               Predictions.update_prediction_set(prediction_set, %{name: nil})

      assert prediction_set.id == Predictions.get_prediction_set!(prediction_set.id).id
    end

    test "delete_prediction_set/1 deletes the prediction_set", %{
      user: user,
      competition: competition
    } do
      prediction_set = prediction_set_fixture(%{user: user, competition: competition})
      assert {:ok, %PredictionSet{}} = Predictions.delete_prediction_set(prediction_set)

      assert_raise Ecto.NoResultsError, fn ->
        Predictions.get_prediction_set!(prediction_set.id)
      end
    end

    test "change_prediction_set/1 returns a prediction_set changeset" do
      prediction_set = prediction_set_fixture()
      assert %Ecto.Changeset{} = Predictions.change_prediction_set(prediction_set)
    end
  end

  defp setup_user_and_competition(context) do
    user = user_fixture()
    competition = competition_fixture()

    Map.merge(context, %{user: user, competition: competition})
  end
end
