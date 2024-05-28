defmodule PredictorWeb.Predictions.PredictionSetLive.Index do
  use PredictorWeb, :live_view

  alias Predictor.Predictions
  alias Predictor.Predictions.Scorer
  alias Predictor.Competitions

  alias Predictor.Repo

  def mount(_params, _session, socket) do
    prediction_sets = Predictions.list_user_prediction_sets(socket.assigns.current_user.id)

    predictions =
      list_predictions(prediction_sets)

    {
      :ok,
      socket
      |> assign(:prediction_sets, prediction_sets)
      |> assign(:predictions, predictions)
    }
  end

  def render(assigns) do
    ~H"""
    <div>
      <.button phx-click={show_modal("competition-select-modal")}>New</.button>

      <.modal id="competition-select-modal">
        <.live_component
          module={PredictorWeb.Predictions.PredictionSetLive.CompetitionSelectForm}
          id="competition-select-form"
          user={@current_user}
        />
      </.modal>

      <.table
        id="prediction_sets"
        rows={@prediction_sets}
        row_click={
          &JS.navigate(
            ~p"/competitions/#{&1.competition.id}/prediction_sets/#{&1.id}/predictions/new"
          )
        }
      >
        <:col :let={ps} label="Name">
          <%= ps.name %>
        </:col>
        <:col :let={ps} label="Competition">
          <%= ps.competition.name %>
        </:col>

        <:col :let={ps} label="Score">
          <%= Scorer.score(@predictions[ps.id]) %>
        </:col>
      </.table>
    </div>
    """
  end

  defp list_predictions(prediction_sets) do
    prediction_sets
    |> Repo.preload(predictions: [:home_team, :away_team, {:match, [:home_team, :away_team]}])
    |> Map.new(fn ps -> {ps.id, ps.predictions} end)
  end
end
