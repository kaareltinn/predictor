defmodule PredictorWeb.Predictions.PredictionLive.TeamCell do
  use PredictorWeb, :live_component

  import PredictorWeb.CoreComponents

  alias Predictor.Competitions
  alias Predictor.Competitions.Match
  alias Predictor.Predictions.Prediction
  alias Predictor.Teams.Team

  def render(%{team: %Team{}} = assigns) do
    ~H"""
    <span>
      <%= @team.name %>
    </span>
    """
  end

  def render(%{match: %Match{user_prediction: nil}, team: nil} = assigns) do
    ~H"""
    <span>
      <.input
        type="select"
        field={@field}
        value={nil}
        form={"prediction-form-#{@match.id}"}
        options={[{"---", nil} | Enum.map(@teams, &{&1.name, &1.id})]}
      />
    </span>
    """
  end

  def render(%{type: :home_team, match: %Match{user_prediction: %Prediction{}}} = assigns) do
    ~H"""
    <span>
      <.input
        type="select"
        field={@field}
        value={@match.user_prediction.home_team_id}
        form={"prediction-form-#{@match.id}"}
        options={[{"---", nil} | Enum.map(@teams, &{&1.name, &1.id})]}
      />
    </span>
    """
  end

  def render(%{type: :away_team, match: %Match{user_prediction: %Prediction{}}} = assigns) do
    ~H"""
    <span>
      <.input
        type="select"
        field={@field}
        value={@match.user_prediction.away_team_id}
        form={"prediction-form-#{@match.id}"}
        options={[{"---", nil} | Enum.map(@teams, &{&1.name, &1.id})]}
      />
    </span>
    """
  end
end
