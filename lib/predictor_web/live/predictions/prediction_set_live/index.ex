defmodule PredictorWeb.Predictions.PredictionSetLive.Index do
  use PredictorWeb, :live_view

  alias Predictor.Competitions
  alias Predictor.Predictions
  alias Predictor.Predictions.PredictionSet
  alias Predictor.Predictions.Prediction

  def mount(_params, _session, socket) do
    prediction_sets = Predictions.list_user_prediction_sets(socket.assigns.current_user.id)

    {
      :ok,
      socket
      |> assign(:prediction_sets, prediction_sets)
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
        />
      </.modal>

      <.table id="prediction_sets" rows={@prediction_sets}>
        <:col :let={ps}>
          {ps.competition.code}
        </:col>
      </.table>
    </div>
    """
  end
end
