defmodule PredictorWeb.Predictions.PredictionSetLive.Index do
  use PredictorWeb, :live_view

  alias Predictor.Predictions

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
        <:col :let={ps} label="Competition">
          <%= ps.competition.name %>
        </:col>
      </.table>
    </div>
    """
  end
end
