defmodule Predictor.Competitions.Competition do
  use Ecto.Schema
  import Ecto.Changeset

  schema "competitions" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(competition, attrs) do
    competition
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end