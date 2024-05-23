defmodule PredictorWeb.LeagueLive.FormComponent do
  use PredictorWeb, :live_component

  alias Predictor.Repo
  alias Predictor.Leagues

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage league records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="league-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          type="select"
          field={@form[:competition_id]}
          label="Competition"
          options={[{"---", nil} | Enum.map(@competitions, &{&1.name, &1.id})]}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save League</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{league: league} = assigns, socket) do
    changeset = Leagues.change_league(league)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"league" => league_params}, socket) do
    changeset =
      socket.assigns.league
      |> Leagues.change_league(league_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"league" => league_params}, socket) do
    save_league(socket, socket.assigns.action, league_params)
  end

  defp save_league(socket, :edit, league_params) do
    case Leagues.update_league(socket.assigns.league, league_params) do
      {:ok, league} ->
        notify_parent({:saved, league})

        {
          :noreply,
          socket
          |> put_flash(:info, "League updated successfully")
          |> push_patch(to: socket.assigns.patch)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_league(socket, :new, league_params) do
    case create_league_with_user(socket.assigns.user, league_params) do
      {:ok, league} ->
        notify_parent({:saved, Repo.preload(league, :competition)})

        {:noreply,
         socket
         |> put_flash(:info, "League created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp create_league_with_user(user, league_params) do
    entry_code = generate_random_entry_code()
    params = Map.put(league_params, "entry_code", entry_code)

    Repo.transaction(fn ->
      with {:ok, league} <- Leagues.create_league(params),
           {_num, _} <- Leagues.upsert_user_league(%{user_id: user.id, league_id: league.id}) do
        league
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp generate_random_entry_code() do
    :crypto.strong_rand_bytes(3) |> Base.encode16(case: :lower)
  end
end
