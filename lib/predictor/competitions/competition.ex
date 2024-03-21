defmodule Predictor.Competitions.Competition do
  use Ecto.Schema
  import Ecto.Changeset

  alias Predictor.Competitions.Match

  schema "competitions" do
    field :name, :string
    has_many :matches, Match, on_delete: :delete_all

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(competition, attrs) do
    competition
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
