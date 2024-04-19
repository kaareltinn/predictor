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
        phx-change="validate"
        phx-submit="save"
        phx-update="ignore"
      >
        <.input field={@form[:name]} label="Name" />
        <.input
          field={@form[:competition_id]}
          label="Competition"
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
    form = to_form(Predictions.change_prediction_set(%Predictions.PredictionSet{}))

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:competitions, competitions)
      |> assign(:form, form)
    }
  end

  def handle_event("validate", params, socket) do
    form = Predictions.change_prediction_set(%Predictions.PredictionSet{}, params) |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", %{"prediction_set" => params}, socket) do
    case Predictions.create_prediction_set(%{
           user_id: socket.assigns.user.id,
           competition_id: params["competition_id"],
           name: params["name"]
         }) do
      {:ok, prediction_set} ->
        {
          :noreply,
          push_navigate(
            socket,
            to:
              ~p"/competitions/#{params["competition_id"]}/prediction_sets/#{prediction_set.id}/predictions/new"
          )
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        dbg(to_form(changeset))
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
