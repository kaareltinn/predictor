defmodule PredictorWeb.Predictions.PredictionLive.Index do
  use PredictorWeb, :live_view

  alias Predictor.Competitions
  alias Predictor.Predictions
  alias Predictor.Predictions.Prediction
  alias PredictorWeb.Predictions.PredictionLive.TeamCell

  def mount(
        %{"competition_id" => competition_id, "prediction_set_id" => prediction_set_id},
        _session,
        socket
      ) do
    competition = Competitions.get_competition!(competition_id)

    prediction_set =
      Predictions.get_prediction_set!(prediction_set_id)

    changeset = Predictions.change_prediction(%Prediction{})

    matches =
      Competitions.list_matches_with_predictions(prediction_set_id)

    teams =
      Competitions.list_competition_teams(competition_id)

    {:ok,
     socket
     |> assign(:competition, competition)
     |> assign(:teams, teams)
     |> assign(:prediction_set, prediction_set)
     |> assign(:matches_by_id, matches_by_id(matches))
     |> assign(:match_ids, match_ids(matches))
     |> assign(:form, to_form(changeset))}
  end

  def handle_info({:saved, prediction}, socket) do
    matches_by_id = socket.assigns.matches_by_id
    match = matches_by_id[prediction.match_id]

    matches_by_id =
      Map.put(matches_by_id, prediction.match_id, %{match | user_prediction: prediction})

    {:noreply, assign(socket, :matches_by_id, matches_by_id)}
  end

  def handle_info({:errors, errors}, socket) do
    {:noreply, put_flash(socket, :error, errors)}
  end

  defp matches_by_id(matches) do
    Map.new(matches, &{&1.id, &1})
  end

  defp match_ids(matches) do
    matches
    |> Enum.sort_by(fn %{code: code} ->
      [_, number] = String.split(code, ":")
      String.to_integer(number)
    end)
    |> Enum.map(& &1.id)
  end
end
