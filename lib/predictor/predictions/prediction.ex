defmodule Predictor.Predictions.Prediction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Predictor.Accounts.User
  alias Predictor.Competitions.Match

  schema "predictions" do
    field :home_goals, :integer
    field :away_goals, :integer
    field :home_penaltis, :integer, default: 0
    field :away_penalties, :integer, default: 0
    belongs_to :user, User
    belongs_to :match, Match

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prediction, %{match: %Match{}, user: %User{}} = attrs) do
    prediction
    |> cast(attrs, [:home_goals, :away_goals, :home_penaltis, :away_penalties])
    |> put_assoc(:match, attrs[:match])
    |> put_assoc(:user, attrs[:user])
    |> validate_required([:home_goals, :away_goals])
  end

  @doc false
  def changeset(prediction, attrs) do
    prediction
    |> cast(attrs, [
      :home_goals,
      :away_goals,
      :home_penaltis,
      :away_penalties,
      :user_id,
      :match_id
    ])
    |> validate_required([:home_goals, :away_goals, :user_id, :match_id])
  end
end
