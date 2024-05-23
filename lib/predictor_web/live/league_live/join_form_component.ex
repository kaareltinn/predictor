defmodule PredictorWeb.LeagueLive.JoinFormComponent do
  use PredictorWeb, :live_component

  alias Predictor.Leagues
  alias Predictor.Predictions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Join league by entering the code and choosing predictions</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="join-league-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:entry_code]} type="text" label="Entry code" />
        <.input
          type="select"
          field={@form[:prediction_set_id]}
          label="Prediction set"
          options={Enum.map(@prediction_sets, &{&1.name, &1.id})}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save League</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{join_league: join_league} = assigns, socket) do
    changeset = Leagues.change_join_league(join_league)
    prediction_sets = Predictions.list_user_prediction_sets(assigns.user.id)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:prediction_sets, prediction_sets)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"join_league" => params}, socket) do
    changeset =
      socket.assigns.join_league
      |> Leagues.change_join_league(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"join_league" => params}, socket) do
    join_league(socket, params)
  end

  defp join_league(
         socket,
         join_league_params
       ) do
    case Leagues.add_user_to_league(
           socket.assigns.user.id,
           socket.assigns.join_league,
           join_league_params
         ) do
      :ok ->
        {
          :noreply,
          socket
          |> put_flash(:info, "League joined successfully")
          |> push_redirect(to: socket.assigns.patch)
        }

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
