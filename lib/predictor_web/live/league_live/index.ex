defmodule PredictorWeb.LeagueLive.Index do
  use PredictorWeb, :live_view

  alias Predictor.Repo
  alias Predictor.Leagues
  alias Predictor.Leagues.League
  alias Predictor.Competitions

  @impl true
  def mount(_params, _session, socket) do
    leagues = Leagues.list_leagues() |> Repo.preload(:competition)

    {:ok,
     socket
     |> stream(:leagues, leagues)
     |> assign(:competitions, Competitions.list_competitions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit League")
    |> assign(:league, Leagues.get_league!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New League")
    |> assign(:league, %League{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Leagues")
    |> assign(:league, nil)
  end

  @impl true
  def handle_info({PredictorWeb.LeagueLive.FormComponent, {:saved, league}}, socket) do
    {:noreply, stream_insert(socket, :leagues, league)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    league = Leagues.get_league!(id)
    {:ok, _} = Leagues.delete_league(league)

    {:noreply, stream_delete(socket, :leagues, league)}
  end
end
