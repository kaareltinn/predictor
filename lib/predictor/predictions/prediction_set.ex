defmodule Predictor.Predictions.PredictionSet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Predictor.Accounts.User
  alias Predictor.Competitions.Competition

  schema "prediction_sets" do
    field :name, :string

    belongs_to :user, User
    belongs_to :competition, Competition

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prediction_set, attrs) do
    prediction_set
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
