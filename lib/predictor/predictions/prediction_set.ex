defmodule Predictor.Predictions.PredictionSet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Predictor.Accounts.User
  alias Predictor.Competitions.Competition
  alias Predictor.Predictions.Prediction

  schema "prediction_sets" do
    field :name, :string

    belongs_to :user, User
    belongs_to :competition, Competition
    has_many :predictions, Prediction

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prediction_set, %{user: %User{}, competition: %Competition{}} = attrs) do
    prediction_set
    |> cast(attrs, [:name])
    |> put_assoc(:user, attrs[:user])
    |> put_assoc(:competition, attrs[:competition])
    |> validate_required([:name, :user, :competition])
  end

  def changeset(prediction_set, attrs) do
    prediction_set
    |> cast(attrs, [:name, :user_id, :competition_id])
    |> validate_required([:name, :user_id, :competition_id])
  end
end
