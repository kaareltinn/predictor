defmodule PredictorWeb.Predictions.PredictionSetLive.Index do
  use PredictorWeb, :live_view

  alias Predictor.Predictions
  alias Predictor.Predictions.Scorer
  alias Predictor.Competitions

  def mount(_params, _session, socket) do
    prediction_sets = Predictions.list_user_prediction_sets(socket.assigns.current_user.id)

    matches_by_prediction_set_id =
      prediction_sets
      |> Enum.map(& &1.id)
      |> Map.new(fn id -> {id, Competitions.list_matches_with_predictions(id)} end)

    {
      :ok,
      socket
      |> assign(:prediction_sets, prediction_sets)
      |> assign(:matches_by_prediction_set_id, matches_by_prediction_set_id)
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
          <%= Scorer.score(@matches_by_prediction_set_id[ps.id]) %>
        </:col>
      </.table>
    </div>
    """
  end
end
