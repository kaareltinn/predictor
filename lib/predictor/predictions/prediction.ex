defmodule Predictor.Predictions.Prediction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Predictor.Accounts.User
  alias Predictor.Competitions.Match

  schema "predictions" do
    field :home_goals, :integer
    field :away_goals, :integer
    field :home_penaltis, :integer
    field :away_penalties, :integer
    belongs_to :user, User
    belongs_to :match, Match

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prediction, attrs) do
    prediction
    |> cast(attrs, [:home_goals, :away_goals, :home_penaltis, :away_penalties])
    |> validate_required([:home_goals, :away_goals, :home_penaltis, :away_penalties])
  end
end
