defmodule Predictor.Leagues.League do
  use Ecto.Schema
  import Ecto.Changeset

  alias Predictor.Competitions.Competition

  schema "leagues" do
    field :name, :string
    field :entry_code, :string
    belongs_to :competition, Competition

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [:entry_code, :name, :competition_id])
    |> validate_required([:entry_code, :name, :competition_id])
    |> unique_constraint(:entry_code)
  end
end
