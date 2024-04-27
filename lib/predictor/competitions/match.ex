defmodule Predictor.Competitions.Match do
  use Ecto.Schema
  import Ecto.Changeset

  alias Predictor.Competitions.Competition
  alias Predictor.Predictions.Prediction
  alias Predictor.Teams.Team

  schema "matches" do
    field :code, :string
    field :status, Ecto.Enum, values: [:scheduled, :in_progress, :finished], default: :scheduled
    field :stage, Ecto.Enum, values: [:group, :eigth, :quarter, :semi, :third, :final]
    field :home_goals, :integer
    field :away_goals, :integer
    field :home_penaltis, :integer
    field :away_penalties, :integer
    field :kickoff_at, :utc_datetime
    belongs_to :home_team, Team
    belongs_to :away_team, Team
    belongs_to :competition, Competition
    has_one :user_prediction, Prediction, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(
        match,
        %{competition: %Competition{}, home_team: %Team{}, away_team: %Team{}} = attrs
      ) do
    match
    |> cast(attrs, [
      :code,
      :home_goals,
      :away_goals,
      :home_penaltis,
      :away_penalties,
      :kickoff_at,
      :status,
      :stage
    ])
    |> put_assoc(:competition, attrs[:competition])
    |> put_assoc(:home_team, attrs[:home_team])
    |> put_assoc(:away_team, attrs[:away_team])
    |> validate_required([
      :code,
      :home_goals,
      :away_goals,
      :home_penaltis,
      :away_penalties,
      :kickoff_at,
      :status,
      :stage
    ])
    |> unique_constraint(:code)
  end

  def changeset(match, attrs) do
    match
    |> cast(attrs, [
      :code,
      :home_goals,
      :away_goals,
      :home_penaltis,
      :away_penalties,
      :kickoff_at,
      :status,
      :stage
    ])
    |> validate_required([
      :code,
      :home_goals,
      :away_goals,
      :home_penaltis,
      :away_penalties,
      :kickoff_at,
      :status,
      :stage
    ])
    |> unique_constraint(:code)
  end
end
