defmodule PredictorWeb.LeagueLive.Show do
  use PredictorWeb, :live_view

  alias Predictor.Leagues
  alias Predictor.Competitions
  alias Predictor.Predictions.Scorer

  alias Predictor.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:league, Leagues.get_league!(id))
     |> assign(:competitions, Competitions.list_competitions())
     |> assign(:prediction_sets, list_prediction_sets(id))}
  end

  defp page_title(:show), do: "Show League"
  defp page_title(:edit), do: "Edit League"

  defp list_prediction_sets(league_id) do
    league_id
    |> Leagues.list_prediction_sets()
    |> Repo.preload([
      :user,
      predictions: [
        :home_team,
        :away_team,
        {:match, [:home_team, :away_team]}
      ]
    ])
  end
end
