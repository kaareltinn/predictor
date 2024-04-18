defmodule PredictorWeb.Predictions.PredictionSetLive.CompetitionSelectForm do
  use PredictorWeb, :live_component

  alias Predictor.Competitions
  alias Predictor.Predictions

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        id="competition-select-form"
        for={@form}
        phx-target={@myself}
        phx-submit="save"
        phx-update="ignore"
      >
        <.input
          field={@form[:competition_id]}
          type="select"
          prompt="Select competition"
          options={Enum.map(@competitions, &{&1.name, &1.id})}
        />

        <.button>Next</.button>
      </.simple_form>
    </div>
    """
  end

  def update(assigns, socket) do
    competitions = Competitions.list_competitions()
    form = to_form(%{"competition_id" => nil})

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:competitions, competitions)
      |> assign(:form, form)
    }
  end

  def handle_event("save", %{"competition_id" => competition_id}, socket) do
    competition = Competitions.get_competition!(competition_id)

    {:ok, prediction_set} =
      Predictions.create_prediction_set(%{
        user: socket.assigns.user,
        competition: competition,
        name: competition.name
      })

    {
      :noreply,
      push_navigate(
        socket,
        to:
          ~p"/competitions/#{competition_id}/prediction_sets/#{prediction_set.id}/predictions/new"
      )
    }
  end
end
