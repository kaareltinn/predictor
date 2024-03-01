defmodule Predictor.Competitions.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    field :code, :string
    field :status, Ecto.Enum, values: [:scheduled, :in_progress, :finished], default: :scheduled
    field :home_goals, :integer
    field :away_goals, :integer
    field :home_penaltis, :integer
    field :away_penalties, :integer
    field :kickoff_at, :utc_datetime
    field :home_team_id, :id
    field :away_team_id, :id
    field :competition_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [
      :code,
      :home_goals,
      :away_goals,
      :home_penaltis,
      :away_penalties,
      :kickoff_at,
      :status
    ])
    |> validate_required([
      :code,
      :home_goals,
      :away_goals,
      :home_penaltis,
      :away_penalties,
      :kickoff_at,
      :status
    ])
    |> unique_constraint(:code)
  end
end
